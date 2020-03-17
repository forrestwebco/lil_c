class AddUniqueTokenToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :unique_token, :string
  end
end
