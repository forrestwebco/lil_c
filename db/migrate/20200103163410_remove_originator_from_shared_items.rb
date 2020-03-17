class RemoveOriginatorFromSharedItems < ActiveRecord::Migration[6.0]
  def change

    remove_column :shared_items, :originator, :string
  end
end
