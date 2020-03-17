class AddIndexToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :index, :integer
  end
end
