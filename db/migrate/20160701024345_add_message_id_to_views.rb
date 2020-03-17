class AddMessageIdToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :message_id, :integer
  end
end
