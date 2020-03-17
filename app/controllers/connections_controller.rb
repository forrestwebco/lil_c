class ConnectionsController < ApplicationController
  before_action :set_item, only: [:new, :create, :update, :destroy,
    :members, :invites, :requests, :following, :followers, :steal_follower]
  before_action :invite_only, except: [:backdoor, :peace, :invite_only_message, :redeem_invite,
      :new, :create, :members, :let_me_in, :zen]
  before_action :invited_or_anrcho, only: [:new, :create, :members]
  before_action :user_access, only: [:invites, :followers]
  before_action :dev_only, only: [:let_me_in] # zenful only for devs in production now

  def index
    @user = User.find_by_unique_token params[:token]
    @following = @user.following
    @followers = @user.followers
    @groups = @user.my_groups
    @views = @user.profile_views
  end

  def let_me_in
    @connection = Connection.new invite: true
    if @connection.save
      cookies[:invite_token] = @connection.unique_token
    end
    redirect_to new_user_path
  end

  def hide_stop_invited_music
    if params[:stop_invited_music]
      cookies[:invited_music_stopped] = true
      @invited_music_stopped = true
    end
  end

  def peace
    if current_user
      current_user.update_token
    end
    cookies.clear
    redirect_to home_path
  end

  def zen
    cookies.clear
    cookies[:zen] = true
    redirect_to new_user_path
  end

  def copy_invite_link
  end

  def invite_only_message
    if anrcho?
      redirect_to proposals_path
    end
    @post = Post.new un_invited: true
    @posts = Post.un_invited.last(10).reverse
    @invite_only_page = true
    @char_bits = char_bits Post.last 10
    @char_codes = char_codes Post.last 10
  end

  def redeem_invite
    @invite = Connection.find_by_unique_token params[:token]
    if @invite and @invite.invited_to_site?
      if !@invite.redeemed
        @invite.update redeemed: true
        if @invite.redeemed
          cookies[:grant_dev_access] = @invite.grant_dev_access
          cookies[:grant_gk_access] = @invite.grant_gk_access
          cookies.permanent[:human] = true
        end
        cookies.permanent[:invite_token] = @invite.unique_token
      # if invite already redeemed in current browser
      elsif @invite.redeemed and invited?
        @already_redeemed = true
      end
      redirect_to new_user_path(@already_redeemed ? { already_redeemed: true } : nil)
    else
      redirect_to '/404'
    end
  end

  def generate_invite
    @invite = Connection.new invite: true,
      grant_dev_access: params[:grant_dev_access],
      grant_mod_access: params[:grant_mod_access]
    if params[:password].present?
      @invite.invite_password = params[:password]
    end
    if @invite.save
      if dev?
        redirect_to dev_panel_path(invite_token: @invite.unique_token)
      else
        redirect_to home_path
      end
    else
      redirect_to dev_panel_path
    end
  end

  def new
    @connection = Connection.new
  end

  def create
    # for inviting users to join a group
    if @group and @user
      invite = @group.invite_to_join @user
      Note.notify(:group_invite, nil, @user, current_user) if invite
    # requesting to join a group
    elsif @group and not params[:user_id]
      request = current_user.request_to_join @group
      if request
        # boolean for ajax
        @requested = true
        # notifies the group creator of a users request to join the group
        Note.notify(:group_request, @group, @group.creator, current_user)
        # notifies all made members of the request to join
        for member in @group.members
          Note.notify(:group_request, @group, member.user, current_user)
        end
      end
    # following another user
    elsif @user
      # follows and sets boolean for ajax script
      connection = current_user.follow @user; @followed = true
      Note.notify(:user_follow, nil, @user, current_user) if connection
    end
    redirect_to invite_from_group_path(@group) unless @followed or @requested
  end

  # when group invite or request is accepted
  def update
    if @connection
      request = @connection.request
      @connection.update invite: false, request: false
      if @connection.group
        @group = @connection.group
        if request
          Note.notify :group_request_accepted, @group, @connection.user, current_user
          @group_request_accepted = true
        end
      end
    end
    redirect_to (@group ? show_group_path(@group.unique_token) : home_path) unless params[:ajax_req].present?
  end

  def destroy
    if @group and @user
      @group.remove @user
    elsif @group
      # removes user from group and sets boolean for ajax
      @group.remove current_user; @left_group = true
    elsif @user
      current_user.unfollow @user
      @unfollowed = true
    elsif @connection
      @connection.destroy
    end
    redirect_to home_path unless @unfollowed or @left_group or params[:ajax_req].present?
  end

  def members
    @members = @group.members
  end

  def invites
    @invites = @user.invites
  end

  def requests
    @requests = @group.requests
  end

  def following
    @following = @user.following.last(10).reverse
  end

  def followers
    @followers = @user.followers.last(10).reverse
  end

  private

  def dev_only
    unless ENV['RAILS_ENV'].eql? 'development'
      redirect_to lacks_permission_path
    end
  end

  def user_access
    if current_user
      unless @user.eql? current_user or dev? or \
        (action_name.eql? 'followers' and current_user.has_power? 'steal_followers', :not_expired)
        redirect_to '/404'
      end
    else
      redirect_to lacks_permission_path
    end
  end

  def invited_or_anrcho
    unless invited? or anrcho?
      redirect_to invite_only_path
    end
  end

  def invite_only
    unless invited?
      redirect_to invite_only_path
    end
  end

  def set_item
    @user = User.find_by_id params[:user_id]
    @group = Group.find_by_id params[:group_id]
    @connection = Connection.find_by_id params[:id] unless @user or @group
  end
end
