class AddSurveySelectionIdToSurveySelections < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_selections, :survey_selection_id, :integer
  end
end
