class AddAcceptedToItemRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :item_requests, :accepted, :boolean, default: false
  end
end
