class AddOtherToSurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_answers, :other, :boolean
  end
end
