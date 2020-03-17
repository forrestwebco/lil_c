class UserMailer < ApplicationMailer
  default from: "#{ENV["EMAIL_USERNAME"]}@gmail.com"

  def item_request(request)
    @user = request.shared_item.user
    @requester = request.user
    @shared_item = request.shared_item

    mail to: @user.email, subject: "Raleigh DSA Lending Library - #{@requester.name.capitalize} would like to borrow your #{@shared_item.name}"
  end
end
