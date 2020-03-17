class ViewsController < ApplicationController
  before_action :dev_or_admin_only, only: [:user_index, :index, :show]

  def create
    if current_user and not in_dev?
      @user = current_user
      @click = View.new click: true, user_id: @user.id
      for i in [:x_pos, :y_pos, :screen_width, :screen_height, :avail_screen_width, :avail_screen_height,
        :device_pixel_ratio, :current_url, :controller_name, :action_name]
        @click.write_attribute(i, params[i])
      end
      if @click.save
        true
      end
    end
  end

  def show
    @view = View.find_by_id params[:id]
  end

  def user_index
    @user = User.find_by_unique_token params[:token]
    @unique_views = []
    for view in @user.views.reverse
      @unique_views << view unless @unique_views.any? { |v| true }
    end
    @views = @unique_views.sort_by { |v| v.created_at }.reverse
  end

  def anon_index
  end

  def click_index
    @user = User.find_by_unique_token params[:token]
    @clicks = @user.views.clicks.reverse
  end

  def index
    @views = View.all.unique_views
    @views = @views.sort_by { |v| v.created_at }.reverse
  end
end
