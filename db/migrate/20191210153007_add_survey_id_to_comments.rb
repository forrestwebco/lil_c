class AddSurveyIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :survey_id, :integer
    add_column :likes, :survey_id, :integer
    add_column :tags, :survey_id, :integer
    add_column :pictures, :survey_id, :integer
  end
end
