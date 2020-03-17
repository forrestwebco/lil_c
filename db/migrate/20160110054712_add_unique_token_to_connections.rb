class AddUniqueTokenToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :unique_token, :string
  end
end
