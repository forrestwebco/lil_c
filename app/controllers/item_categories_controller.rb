class ItemCategoriesController < ApplicationController
  before_action :invite_only
  before_action :set_item_category, only: [:update, :destroy, :show, :edit]
  before_action :new_item_category, only: [:show_form]

  before_action :secure_item_category, only: [:update, :destroy, :edit]

  def show
    unless @item_category
      @item_category = ItemCategory.first
    end
    @shared_items = @item_category.shared_items.reverse
  end

  def index
    @item_categories = ItemCategory.all
  end

  def create
    @item_category = ItemCategory.new(item_category_params)
    @item_category.item_library_id = ItemLibrary.first.id
    @item_category.user_id = current_user.id
    if @item_category.save
      redirect_to item_categories_path
    else
      redirect_to item_categories_path
    end
  end

  def update
    if @item_category.update(item_category_params)
      redirect_to item_categories_path
    else
      render :edit
    end
  end

  def destroy
  end

  def edit
    @editing = true
  end

  private

  def secure_item_category
    unless current_user and @item_category.user_id.eql? current_user.id
      redirect_to lacks_permission_path
    end
  end

  def new_item_category
    @item_category = ItemCategory.new
  end

  def set_item_category
    @item_category = ItemCategory.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_category_params
    params.require(:item_category).permit(:name, :body, :image)
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
