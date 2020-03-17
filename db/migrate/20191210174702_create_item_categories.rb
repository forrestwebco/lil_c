class CreateItemCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :item_categories do |t|
      t.integer :item_library_id
      t.integer :user_id
      t.string :name
      t.string :body
      t.string :image
      t.timestamps
    end
  end
end
