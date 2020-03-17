class AddPortalToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :portal, :boolean
  end
end
