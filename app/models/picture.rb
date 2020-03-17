class Picture < ActiveRecord::Base
  belongs_to :shared_item
  belongs_to :proposal
  belongs_to :product
  belongs_to :post
  belongs_to :user
  belongs_to :survey

  before_create :ensure_order_by_update

  mount_uploader :image, ImageUploader

  validates_presence_of :image

  def move_up
    item = post ? post : (proposal ? proposal : nil)
    ensure_order
    new_order = order - 1
    # get the image above this one being moved down
    img_above = item.pictures.find_by_order new_order
    # moves the img above down
    img_above.update order: order
    # updates with new position
    update order: new_order
  end

  def move_down
    item = post ? post : (proposal ? proposal : nil)
    ensure_order
    new_order = order + 1
    # get the image below this one being moved up
    img_below = item.pictures.find_by_order new_order
    # moves the img below up
    img_below.update order: order
    # updates with new position
    update order: new_order
  end

  # updates all imgs in post with order
  def ensure_order
    item = if post
      post
    elsif proposal
      proposal
    elsif shared_item
      shared_item
    else
    end
    if item.pictures.size > 1
      if order.nil?
        i=0; for img in item.pictures
          img.update order: i if img.order.nil?
          i += 1
        end
      end
      return true
    end
    nil
  end

  def classify
    # switch between tensorflows
    use_tensorflow_rb = false
    if use_tensorflow_rb
      # uses tensorflow ruby gem
      path = self.image_url.to_s; path[0] = ''
      path = Rails.root + path
      name = classify_image path
    else
      # uses tensorflow python library
      path = "http://localhost:3000" + self.image_url.to_s
      name = p `classify "#{path}"`
      # parses output to get name
      name = name.split("\n").last
    end
    # updates picture with name of content
    self.update classifier_name: name
    return self.classifier_name
  end

  private

  def destroy_empty_post
    # if fails, check if text and pictures are both empty, if so, delet
    true
  end

  # still has to account for order of pictures added in update to post
  def ensure_order_by_update
    item = if post_id
      Post.find_by_id post_id
    elsif proposal_id
      Proposal.find_by_id proposal_id
    elsif user_id
      User.find_by_id user_id
    end

    # ensures user is able to update profile pic after having reverted back to old ones
    if item.is_a? User
      for pic in item.profile_pictures
        pic.update reverted_back_to: false
      end
    end

    self.order = item.pictures.size if item
  end
end
