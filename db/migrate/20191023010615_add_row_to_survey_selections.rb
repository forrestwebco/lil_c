class AddRowToSurveySelections < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_selections, :row, :boolean
  end
end
