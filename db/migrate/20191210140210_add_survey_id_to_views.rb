class AddSurveyIdToViews < ActiveRecord::Migration[5.0]
  def change
    add_column :views, :survey_id, :integer
  end
end
