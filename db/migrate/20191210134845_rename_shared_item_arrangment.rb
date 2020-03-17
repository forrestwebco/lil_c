class RenameSharedItemArrangment < ActiveRecord::Migration[5.0]
  def change
    rename_column :shared_items, :arrangment, :arrangement
  end
end
