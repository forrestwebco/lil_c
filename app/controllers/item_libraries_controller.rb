class ItemLibrariesController < ApplicationController
  before_action :invite_only
  before_action :set_item_library, only: [:update, :destroy, :show, :edit]
  before_action :new_item_library, only: [:show_form]

  before_action :secure_item_library, only: [:update, :destroy, :edit]

  def load_more
    @shared_items = paginate ItemLibrary.feed
    page_turning @shared_items
  end

  def filter_and_sort_index
    @item_library = ItemLibrary.first
    @shared_items = @item_library.shared_items
  end

  def show
    # sets up for page turning
    session[:page] = 1
    # ensures red banner shows with appropriate spacing
    @showing_item_library = @show_banner = @no_vertical_spacer = true
    unless @item_library
      @item_library = ItemLibrary.first
    end
    @shared_items_size = ItemLibrary.feed.size
    @shared_items = ItemLibrary.feed.first 10
  end

  def index
    @item_libraries = ItemLibrary.all
  end

  def create
    @item_library = ItemLibrary.new(item_library_params)
    @item_library.user_id = current_user.id
    if @item_library.save
      redirect_to @item_library
    else
      redirect_to new_item_library_path
    end
  end

  def update
  end

  def destroy
  end

  def edit
    @editing = true
  end

  private

  def secure_item_library
    unless (current_user and @item_library.user_id.eql? current_user.id) or admin?
      redirect_to lacks_permission_path
    end
  end

  def new_item_library
    @item_library = ItemLibrary.new
  end

  def set_item_library
    @item_library = ItemLibrary.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_library_params
    params.require(:item_library).permit(:name, :body, :image)
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
