class AdminController < ApplicationController
  before_action :admin_only, only: [:index]
  before_action :dev_only, only: [:dev_panel]

  def index
    @showing_admin_panel = @show_banner = @no_vertical_spacer = true
    @portals = Portal.all
    @dsa_members = User.all
    if params[:portal_token]
      @portal = Portal.find_by_unique_token params[:portal_token]
      if @portal
        @portal_link = home_path.gsub('http', "http#{in_dev? ? '' : 's'}"); @portal_link.slice!(-1)
        @portal_link +=inter_portal_path(@portal.unique_token)
      end
    end
  end


  def dev_panel
    @dev_panel_shown = true
    @char_bits = char_bits Post.last 10
    # creates the invite link to be copied and shared
    if params[:invite_token]
      @invite = Connection.find_by_unique_token params[:invite_token]
      if @invite
        @invite_link = home_path; @invite_link.slice!(-1)
        @invite_link +=redeem_invite_path(@invite.unique_token)
      end
    # creates the portal link to be copied and shared
    elsif params[:portal_token]
      @portal = Portal.find_by_unique_token params[:portal_token]
      if @portal
        @portal_link = home_path.gsub('http', "http#{in_dev? ? '' : 's'}"); @portal_link.slice!(-1)
        @portal_link +=inter_portal_path(@portal.unique_token)
      end
    end
  end

  private

  def admin_only
    unless admin?
      redirect_to lacks_permission_path
    end
  end

  def dev_only
    unless dev?
      redirect_to lacks_permission_path
    end
  end
end
