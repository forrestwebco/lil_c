class RemoveBotFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :bot
  end
end
