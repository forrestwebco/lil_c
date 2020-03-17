class AddRedeemedToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :redeemed, :boolean
  end
end
