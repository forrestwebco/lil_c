class AddOtherToSurveySelections < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_selections, :other, :boolean
  end
end
