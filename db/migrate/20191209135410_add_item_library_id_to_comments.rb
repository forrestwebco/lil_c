class AddItemLibraryIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :item_library_id, :integer
    add_column :tags, :item_library_id, :integer
    add_column :views, :item_library_id, :integer
    add_column :pictures, :item_library_id, :integer
  end
end
