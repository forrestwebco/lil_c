class SurveyResult < ApplicationRecord
  belongs_to :survey
  has_many :survey_answers

  READ_MORE_MIN = 50
end
