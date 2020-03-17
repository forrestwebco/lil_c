class AddItemIdToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :item_id, :integer
  end
end
