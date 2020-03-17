class AddSharedItemIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :shared_item_id, :integer
    add_column :likes, :shared_item_id, :integer
    add_column :tags, :shared_item_id, :integer
    add_column :views, :shared_item_id, :integer
  end
end
