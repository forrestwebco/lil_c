class BlogController < ApplicationController
  before_action :fw_only, only: :index
  before_action :set_fwc
  layout 'co'

  def index
    @blog = true
    @post = Post.new
    @posts = Post.blog.reverse
  end

  private

  def set_fwc
    @forrest_web_co = true
  end
  
  def fw_only
    unless (current_user and current_user.eql? User.first) or in_dev?
      redirect_to root_url
    end
  end
end
