class AddVoteIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :vote_id, :integer
  end
end
