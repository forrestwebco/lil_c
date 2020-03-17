class SurveyBody < ActiveRecord::Migration[5.0]
  def change
    rename_column :surveys, :description, :body
  end
end
