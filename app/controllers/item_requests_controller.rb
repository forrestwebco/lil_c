class ItemRequestsController < ApplicationController
  before_action :set_item_request, only: [:update, :destroy]
  before_action :set_shared_item, only: [:create, :destroy, :index, :show_form]

  def index
    @item_requests = @shared_item.item_requests.reverse
  end

  def create
    @item_request = ItemRequest.new(item_request_params)
    @item_request.attributes = { user_id: current_user.id, shared_item_id: @shared_item.id }
    if @item_request.save
      @shared_item = @item_request.shared_item
      @requester = @item_request.user
      # send email to owner of item that someone is requesting to borrow/use
      UserMailer.item_request(@item_request).deliver if @shared_item.user.email.present?
      unless in_dev?
        # sends sms text message to owner of the item
        if @item_request.valid_phone_number?
          send_twilio_sms @item_request.resolve_phone_number,
            "#{@requester.name.capitalize} would like to borrow your #{@shared_item.name}, contact them to coordinate pickup."
        end
      end

      # notifies owner of the item through the sites notification system
      Note.notify :shared_item_request, @shared_item, @shared_item.user, current_user unless @shared_item.user.eql? current_user
    end
  end

  def update
    @shared_item = @item_request.shared_item
    # accepts item request and sets expiry for item request or duration of use
    if @item_request.update accepted: true, expires_at: @shared_item.days_to_borrow.days.from_now.to_datetime
      @shared_item.update holder_id: @item_request.user.id
      # notifies user that item request was accepted
      Note.notify :shared_item_request_accepted, @shared_item, @item_request.user, current_user
      redirect_to show_shared_item_path @item_request.shared_item.unique_token
    end
  end

  def destroy
    @item_request.destroy
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_request_params
    params.require(:item_request).permit(:body, :chosen_days_to_borrow, :shared_item_id)
  end

  def set_shared_item
    @shared_item = SharedItem.find_by_id params[:shared_item_id]
    @shared_item ||= SharedItem.find_by_id params[:item_request][:shared_item_id]
  end

  def set_item_request
    @item_request = ItemRequest.find params[:id]
  end

  def admin_only
    unless admin?
      redirect_to lacks_permission_path
    end
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
