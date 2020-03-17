class CreateViews < ActiveRecord::Migration[6.0]
  def change
    create_table :views do |t|
      t.integer :user_id
      t.string :anon_token
      t.integer :group_id
      t.integer :post_id

      t.timestamps null: false
    end
  end
end
