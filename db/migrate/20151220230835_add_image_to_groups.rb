class AddImageToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image, :string
    add_column :comments, :image, :string
    add_column :groups, :image, :string
  end
end
