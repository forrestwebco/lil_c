class SurveyQuestionId < ActiveRecord::Migration[5.0]
  def change
    rename_column :survey_answers, :question_id, :survey_question_id
  end
end
