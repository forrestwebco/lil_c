class RemoveHolderFromSharedItems < ActiveRecord::Migration[6.0]
  def change

    remove_column :shared_items, :holder, :string
  end
end
