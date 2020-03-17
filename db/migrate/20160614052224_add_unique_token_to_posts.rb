class AddUniqueTokenToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :unique_token, :string
  end
end
