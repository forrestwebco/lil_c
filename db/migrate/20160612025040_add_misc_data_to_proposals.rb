class AddMiscDataToProposals < ActiveRecord::Migration[6.0]
  def change
    add_column :proposals, :misc_data, :string
  end
end
