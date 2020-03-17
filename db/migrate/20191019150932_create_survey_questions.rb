class CreateSurveyQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_questions do |t|
      t.integer :survey_id
      t.text :body

      t.timestamps
    end
  end
end
