class AddSaltToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :salt, :string
  end
end
