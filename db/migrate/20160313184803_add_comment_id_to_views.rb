class AddCommentIdToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :comment_id, :integer
  end
end
