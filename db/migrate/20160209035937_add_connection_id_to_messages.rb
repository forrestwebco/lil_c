class AddConnectionIdToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :connection_id, :integer
    add_column :connections, :connection_id, :integer
  end
end
