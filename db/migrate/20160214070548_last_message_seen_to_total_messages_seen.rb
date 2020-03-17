class LastMessageSeenToTotalMessagesSeen < ActiveRecord::Migration[6.0]
  def change
    rename_column :connections, :last_message_seen_id, :total_messages_seen
  end
end
