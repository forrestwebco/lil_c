class AddTypeToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :survey_questions, :question_type, :string
  end
end
