class AddInvitePasswordToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :invite_password, :string
  end
end
