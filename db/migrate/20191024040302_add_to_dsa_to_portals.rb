class AddToDsaToPortals < ActiveRecord::Migration[5.0]
  def change
    add_column :portals, :to_dsa, :boolean
  end
end
