class ItemCategory < ApplicationRecord
  belongs_to :user
  has_many :shared_items

  validates_presence_of :name

  mount_uploader :image, ImageUploader
end
