class CreateItemRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :item_requests do |t|
      t.integer :user_id
      t.integer :shared_item_id
      t.string :unique_token
      t.timestamps
    end
  end
end
