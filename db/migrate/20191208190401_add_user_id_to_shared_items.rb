class AddUserIdToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :user_id, :integer
    add_column :item_libraries, :user_id, :integer
  end
end
