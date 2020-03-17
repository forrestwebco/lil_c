class ItemLibrary < ApplicationRecord
  belongs_to :user
  has_many :shared_items
  has_many :comments, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :item_categories, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :body

  before_create :gen_unique_token

  mount_uploader :image, ImageUploader

  def self.feed
    self.first.shared_items.sort_by { |item| item.created_at }.reverse
  end

  def categories
    item_categories
  end

  def holder_options
    # potential holder of lending_library with borrow arrangement and no current holders
    options = [["Holder", nil]]
    holders = []
    for shared_item in shared_items
      holders << shared_item.holder unless holders.include? shared_item.holder
    end
    for holder in holders
      options << [holder.name.capitalize, holder.id] if holder.is_a? User
    end
    options << ["Lending Library", "lending_library"]
    return options
  end

  def category_options
    options = [["Category (domain)", nil]]
    for category in item_categories
      options << [category.name.capitalize, category.id]
    end
    return options
  end

  def self.arrangement_options
    options = [["Arrangement", nil],
      ["Borrow", "borrow"],
      ["Peer to peer", "peer_to_peer"],
      ["On site", "on_site"]]
    return options
  end

  def self.in_stock_options
    options = [["In stock", nil],
      ["Yes", "yes"],
      ["No", "no"]]
    return options
  end

  private

  def gen_unique_token
    begin
      self.unique_token = name_generator
    end while ItemLibrary.exists? unique_token: self.unique_token
  end
end
