class AddMessageFolderToConnections < ActiveRecord::Migration[6.0]
  def change
    add_column :connections, :message_folder, :boolean
  end
end
