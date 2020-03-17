class AddDevToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dev, :boolean
  end
end
