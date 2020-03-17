class AddGatekeeperToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gatekeeper, :boolean
  end
end
