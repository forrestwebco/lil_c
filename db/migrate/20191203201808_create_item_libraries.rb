class CreateItemLibraries < ActiveRecord::Migration[5.0]
  def change
    create_table :item_libraries do |t|
      t.string :name
      t.text :body
      t.string :image
      t.timestamps
    end
  end
end
