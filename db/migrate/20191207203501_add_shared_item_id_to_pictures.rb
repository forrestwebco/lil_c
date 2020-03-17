class AddSharedItemIdToPictures < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :shared_item_id, :integer
  end
end
