class AddBotToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bot, :boolean
  end
end
