class AddVideoToSharedItems < ActiveRecord::Migration[5.0]
  def change
    add_column :shared_items, :video, :string
    add_column :shared_items, :photoset, :boolean
  end
end
