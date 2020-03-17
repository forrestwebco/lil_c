class AddDsaMemberToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :dsa_member, :boolean
  end
end
