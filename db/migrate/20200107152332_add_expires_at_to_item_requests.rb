class AddExpiresAtToItemRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :item_requests, :expires_at, :datetime
  end
end
