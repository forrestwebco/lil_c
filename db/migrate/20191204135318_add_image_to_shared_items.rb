class AddImageToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :image, :string
    add_column :shared_items, :item_library_id, :integer
  end
end
