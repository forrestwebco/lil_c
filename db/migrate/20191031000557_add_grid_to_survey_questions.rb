class AddGridToSurveyQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_questions, :grid, :boolean
  end
end
