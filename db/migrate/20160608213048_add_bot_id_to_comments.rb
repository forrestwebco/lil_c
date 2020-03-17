class AddBotIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :bot_id, :integer
  end
end
