class AddLastMessageSeenIdToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :last_message_seen_id, :integer
  end
end
