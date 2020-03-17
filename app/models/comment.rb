class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :like
  belongs_to :note
  belongs_to :vote
  belongs_to :post
  belongs_to :comment
  belongs_to :proposal
  belongs_to :shared_item
  belongs_to :survey

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tags, dependent: :destroy

  validate :text_or_image?, on: :create

  mount_uploader :image, ImageUploader

  def _likes
    self.likes
  end

  def replies
    self.comments
  end

  private

  def text_or_image?
    if (self.body.nil? or self.body.empty?) and !self.image.url
      errors.add(:comment, "cannot be empty.")
    end
  end
end
