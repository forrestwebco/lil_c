class AddProposalIdToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :proposal_id, :integer
  end
end
