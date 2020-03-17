class AddSurveyResultIdToSurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_answers, :survey_result_id, :integer
  end
end
