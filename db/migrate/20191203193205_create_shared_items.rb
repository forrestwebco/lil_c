class CreateSharedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :shared_items do |t|
      t.string :name
      t.text :description
      t.string :item_type
      t.string :domain
      t.string :size
      t.string :aka
      t.string :arrangment
      t.string :holder
      t.string :originator
      t.string :contact
      t.string :address
      t.boolean :in_stock
      t.timestamps
    end
  end
end
