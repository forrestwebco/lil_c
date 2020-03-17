class AddProfileIdToViews < ActiveRecord::Migration[6.0]
  def change
    add_column :views, :profile_id, :integer
  end
end
