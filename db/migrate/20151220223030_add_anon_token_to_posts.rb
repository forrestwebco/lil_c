class AddAnonTokenToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :anon_token, :string
    add_column :comments, :anon_token, :string
    add_column :messages, :anon_token, :string
    add_column :notes, :anon_token, :string
    add_column :groups, :anon_token, :string
    add_column :tags, :anon_token, :string
  end
end
