class AddGrantModAccessToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :grant_mod_access, :boolean
  end
end
