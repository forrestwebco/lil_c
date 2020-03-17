class AddProposalIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :proposal_id, :integer
  end
end
