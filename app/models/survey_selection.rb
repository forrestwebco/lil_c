class SurveySelection < ApplicationRecord
  belongs_to :survey_question
  belongs_to :survey_selection

  has_many :survey_selections, dependent: :destroy

  validates_presence_of :body

  def get_num
    selections = question.selections
    selections.find_index(self) + 1
  end

  def question_num
    questions = question.survey.questions.to_a
    questions.find_index(question) + 1
  end

  def question
    survey_question
  end
end
