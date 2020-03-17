class AddOpenToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :open, :boolean
  end
end
