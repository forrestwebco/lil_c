class AddProposalIdToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :proposal_id, :integer
  end
end
