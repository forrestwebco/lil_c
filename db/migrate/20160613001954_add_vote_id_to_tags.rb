class AddVoteIdToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :vote_id, :integer
  end
end
