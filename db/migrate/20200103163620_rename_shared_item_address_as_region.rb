class RenameSharedItemAddressAsRegion < ActiveRecord::Migration[6.0]
  def change
    rename_column :shared_items, :address, :region
  end
end
