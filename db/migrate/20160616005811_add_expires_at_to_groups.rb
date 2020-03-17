class AddExpiresAtToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :expires_at, :datetime
  end
end
