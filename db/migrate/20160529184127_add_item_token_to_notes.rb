class AddItemTokenToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :item_token, :string
  end
end
