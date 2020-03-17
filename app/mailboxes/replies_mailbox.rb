class RepliesMailbox < ApplicationMailbox
  # mail => Mail object
  # inbound_mail => ActionMailbox::InboundEmail record

  before_processing :find_user

  MATCHER = /reply-(.+)@reply.example.com/i

  def process
    return unless @user

    if shared_item and shared_item.user.eql? user
      shared_item.comments.create(
        user_id: user.id,
        body: mail.decode
      )
    end
  end

  def find_user
    @user = User.find_by(email: mail.from)
  end

  def shared_item
    @shared_item ||= SharedItem.find shared_item_id
  end

  def shared_item_id
    recipient = mail.recipients.find { |r| MATCHER.match?(r) }
    recipient[MATCHER, 1]
  end
end
