class RenameCategoryId < ActiveRecord::Migration[5.0]
  def change
    rename_column :shared_items, :category_id, :item_category_id
  end
end
