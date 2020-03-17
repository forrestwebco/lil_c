class AddUniqueTokenToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :unique_token, :string
  end
end
