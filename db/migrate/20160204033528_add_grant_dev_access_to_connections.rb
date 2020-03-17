class AddGrantDevAccessToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :grant_dev_access, :boolean
  end
end
