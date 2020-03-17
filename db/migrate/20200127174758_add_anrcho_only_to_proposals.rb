class AddAnrchoOnlyToProposals < ActiveRecord::Migration[6.0]
  def change
    add_column :proposals, :anrcho_only, :boolean
  end
end
