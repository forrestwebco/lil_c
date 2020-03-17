class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :update_password,
    :destroy, :load_more_items, :toggle_old_profile_pics, :switch_back_to_old_profile_picture]
  before_action :secure_user, only: [:edit, :update, :destroy, :switch_back_to_old_profile_picture]
  before_action :dev_or_admin_only, only: [:index]
  before_action :invite_only

  def switch_back_to_old_profile_picture
    # gets old profile pic being reverted back to
    @picture = Picture.find_by_id params[:id]
    # updates to revert back to this profile pic
    if @picture.update reverted_back_to: true
      for pic in @user.profile_pictures

        # not working because of self.img of user that is still in play
        # could fix by removing from db altogether, updating all users to incorporate new profile pic model

        # undos all revert back tos from before
        if pic.is_a? Picture and pic.reverted_back_to and not pic.eql? @picture
          pic.update reverted_back_to: false
        end
      end
      # success for js
      @reverted = true
    end
  end

  def update_scrolling_avatar
    @post = Post.find_by_id params[:post_id]
    @proposal = Proposal.find_by_id params[:proposal_id]
    @item = @post ? @post : @proposal
    if @item.user
      @user = @item.user
    else
      @anon_token = @item.anon_token
    end
  end

  def load_more_items
    build_feed
    page_turning @items
  end

  def geolocation
  end

  def hide_featured_users
    cookies.permanent[:hide_featured_users] = true
  end

  def new
    unless current_user
      reset_page
      # to ignore infinite scroll
      @preview_items = true
      @user = User.new
      # gets preview items for invitee
      @all_items = Post.preview_feed
      # pagination for infinite_scroll
      @items = paginate @all_items
      @char_codes = char_codes @items
      @char_bits = char_bits @items
      # records user viewing posts
      @items.each { |item| seent item }
    end
  end

  def create
    @user = User.new(user_params)
    # access rights from invite
    grant_access_rights
    if @user.save
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      cookies.permanent[:logged_in_before] = true
      # records current time for last visit (first visit)
      record_last_visit

      unless current_user.eql? User.first
        # automatically follows website creator at sign up so feed is full
        connection = current_user.follow User.first if current_user
        Note.notify(:user_follow, nil, User.first, current_user) if connection

        # website creator automatically follows new user back
        connection = User.first.follow current_user if current_user
        Note.notify(:user_follow, nil, current_user, User.first) if connection
      end

      # creates first item library if none exist
      ItemLibrary.create name: "Lending Library", body: "Share items and services" if ItemLibrary.all.empty?

      # returns to home page, main feed
      redirect_to home_path
    else
      redirect_to home_path, notice: "Please fill all fields."
    end
  end

  def index
    @admin_user_index = true
    # creates array of active users and sorts by date last active
    active_users = []; User.where.not(last_active_at: nil).each { |user| active_users << user }
    active_users.sort_by! { |user| user.last_active_at }.reverse!
    # creates array of inactive users and just sorts by time of creation
    inactive_users = []; User.where(last_active_at: nil).each { |user| inactive_users << user }
    inactive_users.sort!.reverse!
    # adds both arrays together for finale
    @users = active_users + inactive_users
  end

  def show
    @showing_user_profile = @show_banner = @no_vertical_spacer = true
    if @user
      show_user_thingy_to_run
    end
  end

  def edit
  end

  def update
    # still need to ensure user has correct permissions in order to update dev, admin, mod
    if @user.update(user_params.except(:image))
      @user.pictures.create image: params[:user][:image]
      Tag.extract @user
      redirect_to edit_user_path(@user), notice: "Profile/account updated successfully."
    else
      redirect_to edit_user_path(@user), notice: "Unable to update profile/account... Error."
    end
  end

  def update_password
    @auth_user = User.authenticate(current_user.name, params[:old_password])
    if @auth_user or dev?
      @user.password = user_params[:password]
      @user.encrypt_password
      if @user.save
        @success = true
      end
    end
    @notice = if @success
      "Password updated successfully."
    else
      "Password update failed... Error."
    end
    redirect_to edit_user_path(@user), notice: @notice
  end

  def destroy
    @user.destroy unless @user.dev
    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private

  def build_feed
    @items = paginate @user.profile_feed
  end

  def show_user_thingy_to_run
    if @requested_by_integer_id
      redirect_to show_user_path @user.unique_token
    end
    reset_page
    # solves loading error
    session[:page] = 1
    @post = Post.new
    @posts = @user.posts
    @shared_items = @user.shared_items
    @surveys = @user.surveys
    @items_size = @user.profile_feed.size
    @items = @user.profile_feed.first 10
    @views = @user.profile_views
    @char_bits = char_bits @items
    @user_shown = true
    # records being seen
    seent @user
  end

  def grant_access_rights
    # saves as dsa member if dsa site
    if raleigh_dsa? and invited?
      @user.dsa_member = true
    end
    # grants admin privilege sent with invite
    if cookies[:grant_admin_access]
      # deletes to prevent creation of multiple admins
      cookies.delete(:grant_admin_access)
      @user.admin = true
    end
    # grants dev powers sent with invite
    if cookies[:grant_dev_access]
      # deletes to prevent creation of multiple devs
      cookies.delete(:grant_dev_access)
      @user.dev = true
    end
  end

  def invite_only
    token_good = User.find_by_unique_token @user.unique_token if @user
    unless invited?
      redirect_to sessions_new_path unless token_good
    end
  end

  def dev_only
    redirect_to lacks_permission_path unless dev?
  end

  def dev_or_admin_only
    redirect_to lacks_permission_path unless dev? or admin?
  end

  def secure_user
    set_user; redirect_to lacks_permission_path unless current_user.eql? @user or dev? or admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  # set to recieve request by 64bit unique_token or regular integer ID
  def set_user
    if params[:token]
      @user = User.find_by_unique_token params[:token]
      @user ||= User.find_by_name params[:token]
      @user ||= User.find_by_id params[:token]
    else
      @user = User.find_by_unique_token params[:id]
      @user ||= User.find_by_name params[:id]
      @user ||= User.find_by_id params[:id]
      # for redirection to the more secure path
      @requested_by_integer_id = true if @user
    end
    redirect_to '/404' unless @user or params[:id].nil?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :image, :body, :title, :password, :password_confirmation, :featured, :admin, :mod, :dev)
  end
end
