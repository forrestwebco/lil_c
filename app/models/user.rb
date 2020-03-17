class User < ActiveRecord::Base
  has_many :connections, dependent: :destroy
  has_many :settings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :proposals, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :item_libraries
  has_many :shared_items
  has_many :surveys
  has_many :portals
  has_many :groups

  has_many :access_grants,
    class_name: 'Doorkeeper::AccessGrant',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
    class_name: 'Doorkeeper::AccessToken',
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  validates_uniqueness_of :name
  validates_presence_of :name, length: { minimum: 3 }
  validates_presence_of :password, length: { minimum: 4 }
  validates_confirmation_of :password

  before_create :encrypt_password, :generate_token, :gen_unique_token, :gen_energy_points
  after_create :initialize_settings

  mount_uploader :image, ImageUploader

  scope :featured, -> { where featured: true }
  scope :dsa_members, -> { where dsa_member: true }

  # finds @ mention for user with name including spaces
  def self.spaced_name_has_at? text
    if text.include? "@"
      text = text.split " "
      name = ""; started = false; len = 0; for t in text
        # only removes @ for first word containing @
        if t.include? "@"
          name << t.slice(t.index("@")+1..t.size)
          started = true
          len += 1
        # otherwise only inserts word with prepended space
        elsif started
          name << " " + t
          len += 1
        end
        u = find_by_name name
        break if u
      end
    end
    return { user: u, len: len }
  end

  def my_cart
    Cart.initialize self if cart.nil? or not cart.product_token_list.present?
    return cart
  end

  def my_wish_list
    WishList.initialize self if wish_list.nil? or not wish_list.product_token_list.present?
    return wish_list
  end

  def profile_feed
    _feed = []
    for post in posts
      _feed << post unless _feed.include? post
    end
    for proposal in proposals
      _feed << proposal unless _feed.include? proposal or proposal.anrcho_only
    end
    for shared_item in shared_items
      _feed << shared_item unless _feed.include? shared_item
    end
    for survey in surveys
      _feed << survey unless _feed.include? survey
    end
    # removes hidden posts or hidden users posts
    _feed.delete_if do |item|
      true if item.is_a? Post and item.blog
    end
    _feed.sort_by { |item| item.created_at }.reverse
  end

  def feed
    _feed = []
    # all posts from users followed
    for user in following
      user.posts.each { |post| _feed << post unless post.social_maya_only }
    end
    # all posts from my groups
    for group in my_groups
      group.posts.each do |post|
        _feed << post unless _feed.include? post
      end
      group.proposals.each do |proposal|
        _feed << proposal unless _feed.include? proposal
      end
    end
    # all of users own posts
    self.posts.each do |post|
      _feed << post unless _feed.include? post or post.social_maya_only
    end
    # all anonymous posts if dev or has power
    if dev?
      for post in Post.where(un_invited: nil).where.not(anon_token: nil)
        _feed << post unless _feed.include? post or post.social_maya_only
      end
    end
    # gets all active or ratified global proposals for feed
    Proposal.globals.each do |proposal|
      _feed << proposal unless _feed.include? proposal or proposal.anrcho_only
    end
    # gets all surveys created
    Survey.all.each do |survey|
      _feed << survey unless _feed.include? survey
    end
    # gets all shared items from all item_libraries
    SharedItem.all.each do |shared_item|
      _feed << shared_item unless _feed.include? shared_item
    end
    # removes hidden posts or hidden users posts
    _feed.delete_if do |item|
      if item.is_a? Post and not item.user.eql? self
        if item.hidden
          true
        elsif item.user and item.user.hidden
          true
        end
      end
      true if item.is_a? Post and item.blog
    end
    # sorts posts/proposals chronologically or by score weight
    _feed.sort_by! { |item| item.created_at }
    #_feed.sort_by! { |item| item.created_at }
    return _feed.reverse
  end

  def old_profile_pictures
    pics = []; for pic in profile_pictures
      pics << pic unless pic.eql? current_profile_picture
    end
    pics
  end

  def current_profile_picture
    # check for new img way
    if pictures.present?
      # if reverted back to old profile pic, return that
      reverted = pictures.where reverted_back_to: true
      if reverted.present?
        return reverted.last
      else
        # else just return newest uploaded profile pic
        return pictures.last
      end
    end
    nil
  end

  def profile_pictures
    pictures
  end

  def dup_profile_pic_made?
    if image_url and pictures.present?
      pic_name = image_url.split("/").last
      for pic in pictures
        this_pic_name = pic.image_url.split("/").last
        return true if this_pic_name.eql? pic_name
      end
    end
    nil
  end

  def profile_views
    View.where profile_id: id
  end

  def following? other_user
    self.connections.where(other_user_id: other_user.id).present?
  end

  def follow other_user
    self.connections.create other_user_id: other_user.id
  end

  def unfollow other_user
    connection = self.connections.find_by_other_user_id(other_user.id)
    connection.destroy if connection
  end

  def following
    _following = []
    self.connections.each do |connection|
      user = User.find_by_id(connection.other_user_id)
      _following << user if user
    end
    return _following
  end

  def followers
    _followers = []
    Connection.where(other_user_id: self.id).each do |connection|
      _followers << connection.user if connection.user
    end
    return _followers
  end

  def request_to_join group
    self.connections.create group_id: group.id, request: true
  end

  def my_groups
    _my_groups = []
    self.groups.each { |group| _my_groups << group }
    # gets only the connections to groups already joined
    self.connections.current.where.not(group_id: nil).each do |connection|
      _my_groups << connection.group if connection.group
    end
    # sorts by the time the connection was established (time of joining)
    _my_groups.sort_by! { |connection| connection.created_at }
    return _my_groups
  end

  def invites
    self.connections.invites
  end

  def requests
    self.connections.requests
  end

  def inbox_unseen
    unseen = 0
    for folder in self.message_folders
      unseen_msgs = folder.unseen_messages(self)
      unseen += unseen_msgs if unseen_msgs > 0
    end
    return unseen
  end

  def folder_between user
    for folder in self.message_folders
      if folder.connections.size.eql? 2 and folder.connections.where(user_id: user.id).present?
        _folder = folder
      end
    end
    return _folder
  end

  def message_folders
    folders = []
    self.connections.where.not(connection_id: nil).each do |connection|
      if connection.connection and connection.connection.message_folder
        folders << connection.connection
      end
    end
    return folders
  end

  def _likes
    self.likes
  end

  def initialize_settings
    _settings = Setting.names
    # puts names from both categories into one array
    names = _settings[:on]; _settings[:state].each { |name| names << name }
    # creates any new settings not yet initialized
    unless names.size.eql? self.settings.size
      for name in names
        self.settings.create name: name unless self.settings.find_by_name name
      end
    else
      # renames settings based on names array
      i=0; for setting in self.settings
        setting.update name: names[i]; i+=1
      end
    end
  end

  def update_token
    self.generate_token
    self.save
  end

  def generate_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists? auth_token: self.auth_token
  end

  def self.authenticate login, password
    user = self.find_by_name login
    # in case the their name is capitalized
    user ||= self.find_by_name login.capitalize
    # in case their name is all lower case
    user ||= self.find_by_name login.downcase
    # in case they're logging in by email
    user ||= self.find_by_email login
    # if user found and password matches decrypted one saved in db
    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(self.password, self.password_salt)
    end
  end

  private

  def gen_unique_token
    begin
      self.unique_token = SecureRandom.urlsafe_base64
    end while User.exists? unique_token: self.unique_token
  end

  def gen_energy_points
    self.energy_points = rand 1000
  end
end
