class UserBioToBody < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :bio, :body
  end
end
