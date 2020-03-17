class AddQuestionBodyToSurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_answers, :question_body, :text
    add_column :survey_answers, :question_id, :integer
  end
end
