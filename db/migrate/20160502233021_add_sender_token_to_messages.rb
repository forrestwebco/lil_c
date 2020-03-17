class AddSenderTokenToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :sender_token, :string
  end
end
