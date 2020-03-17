class AddBlogToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :blog, :boolean
  end
end
