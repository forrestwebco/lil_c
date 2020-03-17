class RemoveGodColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :god
    remove_column :users, :goddess
    remove_column :users, :gatekeeper

    remove_column :portals, :god
    remove_column :portals, :goddess
  end
end
