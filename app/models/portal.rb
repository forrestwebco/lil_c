class Portal < ActiveRecord::Base
  belongs_to :user

  before_create :gen_unique_token, :initialize_portal
  before_destroy :destroy_dependent_portals

  after_update :close_if_used_up

  DEFAULT_REMAINING_USES = 1

  scope :loners, -> { where cluster: nil, cluster_id: nil }
  scope :clusters, -> { where cluster: true }

  def self.to_anrcho user
    anrcho_portals = user.portals.where to_anrcho: true
    if anrcho_portals.present?
      return anrcho_portals.last
    else
      portal = user.portals.new to_anrcho: true
      return portal if portal.save
    end
    nil
  end

  def _cluster
    if self.cluster_id
      Portal.where(cluster: true).find_by_id self.cluster_id
    else
      nil
    end
  end

  def portals
    if self.cluster
      Portal.where cluster_id: self.id
    else
      nil
    end
  end

  def self.expiration_date
    1.week.from_now.to_datetime
  end

  private

  def gen_unique_token
    begin
      self.unique_token = name_generator
    end while Portal.exists? unique_token: self.unique_token
  end

  def close_if_used_up
    destroy if remaining_uses.zero?
  end

  def destroy_dependent_portals
    if self.cluster
      for portal in self.portals
        portal.destroy
      end
    end
  end

  # defaults to 5 uses and expires a week from now
  def initialize_portal
    self.expires_at ||= Portal.expiration_date
    self.remaining_uses ||= DEFAULT_REMAINING_USES
  end
end
