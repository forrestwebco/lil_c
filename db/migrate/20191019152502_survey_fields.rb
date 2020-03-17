class SurveyFields < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :title, :string
    add_column :surveys, :description, :text
    add_column :surveys, :image, :string
    add_column :surveys, :user_id, :integer
    add_column :surveys, :questions, :text
    add_column :surveys, :group_id, :integer
  end
end
