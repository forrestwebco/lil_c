class Survey < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :views, dependent: :destroy
  has_many :pictures, dependent: :destroy

  has_many :survey_questions, dependent: :destroy
  has_many :survey_results, dependent: :destroy
  has_many :views, dependent: :destroy

  validates_presence_of :title
  validates_presence_of :body

  before_create :gen_unique_token

  mount_uploader :image, ImageUploader

  READ_MORE_MIN = 50

  def score user=nil, get_weights=nil
    1
  end

  def _likes
    likes
  end

  def get_questions_by_page page_num, page_size=5
    if questions.size >= page_num * page_size
      return questions.
        # drops first several posts
        drop(page_num * page_size).
        # only shows first several posts of resulting array
        first(page_size)
    end
  end

  def get_question_by_num num
    _questions = questions.to_a
    _questions[num.to_i - 1]
  end

  def questions
    survey_questions.order('id ASC')
  end

  def open_ended_questions
    questions = []
    survey_questions.where(grid: nil, question_type: ['open_ended', 'open_ended_paragraph', nil]).each do |question|
      # ignores the following questions with this text
      unless ['phone', 'phone number', 'email'].any? { |word| question.body.downcase.eql? word }
        questions << question
      end
    end
    questions
  end

  def checkbox_questions
    survey_questions.where grid: nil, question_type: 'checkbox'
  end

  def radio_button_questions
    survey_questions.where grid: nil, question_type: 'radio_button'
  end

  def grid_questions
    survey_questions.where grid: true
  end

  def grid_question_options
    questions = survey_questions.where grid: true
    questions_array = [["Select a grid question to filter by", nil]]
    for question in questions
      questions_array << [Survey.snip_txt(question.body.squish, :small), question.id]
    end
    questions_array
  end

  def self.snip_txt txt, small=nil
    if txt.present? and txt.size > READ_MORE_MIN
      _txt = txt[0..(small ? 25 : READ_MORE_MIN)]
      _txt[-1] = "" if _txt[-1].eql? " "
      _txt + "..."
    else
      txt
    end
  end

  def results
    survey_results
  end

  private

  def gen_unique_token
    begin
      self.unique_token = name_generator
    end while Survey.exists? unique_token: self.unique_token
  end
end
