class SharedItemsController < ApplicationController
  before_action :invite_only
  before_action :set_shared_item, only: [:update, :destroy, :show, :edit, :add_photoset, :confirm_return, :show_modal, :read_more, :open_menu, :close_menu]
  before_action :set_item_library, only: [:filter_by, :reset_filter, :sort_by, :add_filter_field, :set_filter_field]
  before_action :new_shared_item, only: [:show_form]
  before_action :set_comments, only: [:show_modal, :show]
  before_action :set_field, only: [:read_more, :remove_filter_field]
  before_action :secure_shared_item, only: [:update, :destroy, :edit]

  def open_menu
    @showing = params[:showing]
  end

  def read_more
    @read_more = true
  end

  def add_filter_field
    @item_library = ItemLibrary.find_by_id params[:item_library_id]
    @selected_filter_field = params[:selected_filter_field].to_sym
  end

  def confirm_return
    borrower = @shared_item.current_borrower
    if borrower
      request = @shared_item.request_by(borrower)
      if request.destroy and @shared_item.update holder_id: nil
        Note.notify :shared_item_returned, @shared_item, borrower, current_user
      end
    end
    redirect_to show_shared_item_path(@shared_item.unique_token)
  end

  def filter_by
    @_shared_items = @item_library.shared_items
    @shared_items = []
    for shared_item in @_shared_items
      for field in shared_item_fields
        # if there was any filter input for this field
        if params[field].present?
          # if the filter input matches this field
          if params[field].eql? shared_item.send(field).to_s \
            or (field.eql? :holder_id and params[field].eql? shared_item_holder(shared_item)) \
            or (field.eql? :in_stock and shared_item.currently_in_stock.eql? params[field]) \
            # append item unless its already been added
            @shared_items << shared_item unless @shared_items.include? shared_item
          # remove item if any input doesn't match its answer
          else
            @shared_items.delete shared_item if @shared_items.include? shared_item # may be redundant, may remove soon
            break
          end
        end
      end
    end
  end

  def reset_filter
    @shared_items = @item_library.shared_items
    if params[:toggle_stacked].present?
      if cookies[:stacked_shared_items_set_to_vertical].present?
        cookies[:stacked_shared_items_set_to_vertical] = ""
      else
        cookies[:stacked_shared_items_set_to_vertical] = true
      end
    end
  end

  def sort_by
    @shared_items = if params[:order].present?
      # uses filtered result ids if any
      shared_items = @item_library.shared_items
      # sorts by order for question
      shared_items.sort_by do |shared_item|
        case params[:field]
        when 'holder_id'
          shared_item_holder shared_item
        when 'in_stock'
          shared_item.currently_in_stock
        else
          shared_item.send params[:field]
        end
      end
    else
      @item_library.shared_items
    end
    @shared_items.reverse! if params[:order].present? and params[:order].eql? 'down'
  end

  def show_form
    @item_library = ItemLibrary.find_by_id params[:item_library_id]
    if params[:from_home]
      @from_home = true
    end
  end

  def show
    @comments = @shared_item.comments
    @comment = Comment.new
  end

  def index
    @item_libraries = SharedItem.all
  end

  def create
    @item_library = ItemLibrary.first
    @shared_item = @item_library.shared_items.new(shared_item_params)
    @shared_item.user_id = current_user.id
    # sets as photoset for validation
    if params[:pictures]
      @shared_item.photoset = true
    end
    if @shared_item.save
      if params[:pictures]
        # builds photoset for shared item
        params[:pictures][:image].each do |image|
          @shared_item.pictures.create image: image
        end
        # adds order numbers to each picture in photoset if more than 1
        @shared_item.pictures.first.ensure_order if @shared_item.pictures.present? and @shared_item.pictures.size > 1
      end
    end
    if params[:from_home]
      redirect_to home_path
    else
      redirect_to @shared_item.item_library
    end
  end

  def update
    if @shared_item.update(shared_item_params)
      if params[:pictures]
        # builds photoset for shared item
        params[:pictures][:image].each do |image|
          @shared_item.pictures.create image: image
        end
        # adds order numbers to each picture in photoset if more than 1
        @shared_item.pictures.first.ensure_order if @shared_item.pictures.present? and @shared_item.pictures.size > 1
      end
      redirect_to show_shared_item_path(@shared_item.unique_token)
    else
      render :edit
    end
  end

  def destroy
    @shared_item.destroy
    redirect_to home_path unless str_to_bool params[:ajax_req]
  end

  def edit
    @editing = true
  end

  def hide_arrangement_types_card
    cookies[:hide_arrangement_types_card] = true
  end

  private

  def set_field
    @field = params[:field]
  end

  def set_comments
    @comments = @shared_item.comments
    @comment = Comment.new
    # this method is only used when showing item on own page or in modal
    @showing = true
  end

  def shared_item_holder shared_item
    if shared_item.holder.is_a? User
      shared_item.holder.id.to_s
    else
      shared_item.holder
    end
  end

  def set_item_library
    @item_library = ItemLibrary.find_by_id params[:id]
  end

  def secure_shared_item
    unless current_user and @shared_item.user_id.eql? current_user.id or admin?
      redirect_to home_path
    end
  end

  def new_shared_item
    @shared_item = SharedItem.new
  end

  def set_shared_item
    if params[:unique_token]
      @shared_item = SharedItem.find_by_unique_token(params[:unique_token])
      @shared_item ||= SharedItem.find_by_id(params[:unique_token])
    else
      @shared_item = SharedItem.find_by_unique_token(params[:id])
      @shared_item ||= SharedItem.find_by_id(params[:id])
    end
    redirect_to '/404' unless @shared_item
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def shared_item_params
    params.require(:shared_item).permit(:name, :body, :image, :item_type, :size, :aka, :arrangement,
      :contact, :region, :video, :item_category_id, :holder_id, :days_to_borrow)
  end

  def shared_item_fields
    [:name, :body, :item_type, :item_category_id, :size, :aka, :arrangement, :contact, :region, :holder_id, :days_to_borrow, :in_stock]
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
