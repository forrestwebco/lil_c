class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.integer :post_id
      t.string :image
      t.timestamps null: false
    end
  end
end
