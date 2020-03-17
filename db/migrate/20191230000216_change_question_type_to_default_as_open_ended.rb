class ChangeQuestionTypeToDefaultAsOpenEnded < ActiveRecord::Migration[6.0]
  def change
    change_column :survey_questions, :question_type, :string, default: 'open_ended'
  end
end
