class AddAnonTokenToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :anon_token, :string
  end
end
