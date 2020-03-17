class AddPhotosetToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :photoset, :boolean
  end
end
