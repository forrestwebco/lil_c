class AddModToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mod, :boolean
  end
end
