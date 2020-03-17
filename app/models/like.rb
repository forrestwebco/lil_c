class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :comment
  belongs_to :proposal
  belongs_to :like
  belongs_to :vote
  belongs_to :survey
  belongs_to :shared_item

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_create :gen_unique_token
  before_destroy :destroy_note

  validate :unique_to_item?, on: :create

  def like_type plural=nil
    _type = "#{plural ? '_' : ''}like"
    _type << "s" if plural
    return _type
  end

  def _likes
    self.likes
  end

  private

  def destroy_note
    if like_id
      note = Note.where(action: "like_like").find_by_item_id like_id
      note.destroy if note
    end
  end

  def unique_to_item?
    if self.post_id
      if self.user_id
        if Post.find(self.post_id).likes.where(user_id: self.user_id).present?
          errors.add :like, "Not unique like by user"
        end
      elsif self.anon_token
        if Post.find(self.post_id).likes.where(anon_token: self.anon_token).present?
          errors.add :like, "Not unique like by anon"
        end
      end
    elsif self.proposal_id
      if self.user_id
        if Proposal.find(self.proposal_id).likes.where(user_id: self.user_id).present?
          errors.add :like, "Not unique like of motion by user"
        end
      elsif self.anon_token
        if Proposal.find(self.proposal_id).likes.where(anon_token: self.anon_token).present?
          errors.add :like, "Not unique like of motion by anon"
        end
      end
    end
  end

  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
