class AddGroupIdToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :group_id, :integer
  end
end
