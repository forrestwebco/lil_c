class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  has_many :survey_answers, dependent: :destroy
  has_many :survey_selections, dependent: :destroy

  validates_presence_of :body

  before_create :defaults_to_open_ended

  READ_MORE_MIN = 50
  SUMMARY_MAX = 5

  def open_question_type
    case question_type
    when nil, 'open_ended'
      'short answer'
    when 'open_ended_paragraph'
      'paragraph'
    end
  end

  def open_ended?
    question_type.blank? or question_type.eql? 'open_ended' or question_type.eql? 'open_ended_paragraph'
  end

  def title
    body.split("\r\n\r\n").first if body.include? "\r\n\r\n"
  end

  def body_without_title
    body.split("\r\n\r\n")[1..-1].last if body.include? "\r\n\r\n"
  end

  def get_selection_by_num num
    _selections = grid ? columns : selections
    _selections.to_a[num.to_i - 1]
  end

  def has_other?
    selections.where(other: true).present?
  end

  def add_other param
    # only creates one other selection unless grid
    if param.present? and not self.grid and not selections.where(other: true).present?
      s = selections.create body: "other", other: true
    end
  end

  def get_num
    questions = survey.questions
    questions.find_index(self) + 1
  end

  def selections
    survey_selections
  end

  def make_grid_selections selections, params, param
    # gets row and column from param/input
    if question_type.eql? 'checkbox'
      row = rows.to_a[param.split("_").last(3).first.to_i - 1].body
      column = columns.to_a[param.split("_").last.to_i - 1].body
    else
      # gets row and column for radio button input
      row = rows.to_a[param.split("_").last(2).first.to_i - 1].body
      column = columns.to_a[params[param].to_i - 1].body
    end
    selections << [row, [column]]
    selections
  end

  def rows
    survey_selections.where row: true
  end

  def columns
    if grid
      survey_selections.where row: nil
    else
      []
    end
  end

  def radio_button_options
    if question_type.eql? 'radio_button'
      options = [[Survey.snip_txt(body, :small), nil]]
      for selection in survey_selections
        options << [Survey.snip_txt((selection.other ? "Other..." : selection.body), :small), selection.body]
      end
      options
    else
      []
    end
  end

  private

  def defaults_to_open_ended
    self.question_type = 'open_ended' if self.question_type.blank?
  end
end
