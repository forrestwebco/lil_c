class RenameGroupDescriptionToBody < ActiveRecord::Migration[6.0]
  def change
    rename_column :groups, :description, :body
  end
end
