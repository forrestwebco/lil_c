class AddHolderIdToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :holder_id, :integer
  end
end
