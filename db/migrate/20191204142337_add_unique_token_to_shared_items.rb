class AddUniqueTokenToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :unique_token, :string
    add_column :item_libraries, :unique_token, :string
  end
end
