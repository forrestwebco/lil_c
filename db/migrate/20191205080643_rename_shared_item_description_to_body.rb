class RenameSharedItemDescriptionToBody < ActiveRecord::Migration[5.0]
  def change
    rename_column :shared_items, :description, :body
  end
end
