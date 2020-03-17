class AddSocialMayaOnlyToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :social_maya_only, :boolean
  end
end
