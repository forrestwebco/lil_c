class AddCategoryIdToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :category_id, :integer
  end
end
