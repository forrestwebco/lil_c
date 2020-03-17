class SurveyQuestionsController < ApplicationController
  before_action :surveys
  before_action :invite_only, except: [:next, :back]
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :set_question_num, only: [:set_type, :remove]
  before_action :set_survey, only: [:next, :back]

  def add_filter_field
    @survey = Survey.find_by_id params[:survey_id]
    @question = SurveyQuestion.find_by_id params[:selected_survey_question_id].to_i
  end

  def next
    if cookies["take_survey_page_num"].present?
      cookies[:take_survey_page_num] = cookies[:take_survey_page_num].to_i + 1
    else
      cookies[:take_survey_page_num] = 1
    end
    @page_num = cookies[:take_survey_page_num].to_i
    if @page_num > 0
      @show_back = true
      if @survey.get_questions_by_page(@page_num + 1).present?
        @show_next = true
      else
        @show_submit = true
        @hide_next = true
      end
    end
    @show_middle_dot = (@show_back and @show_next) or (@show_back and @show_submit)
  end

  def back
    if cookies["take_survey_page_num"].present?
      cookies[:take_survey_page_num] = cookies[:take_survey_page_num].to_i - 1
      @page_num = cookies[:take_survey_page_num].to_i
      if @page_num < 1
        @hide_back = true
      end
      @show_next = true
      @hide_submit = true
    end
  end

  def remove
    cookies[:question_num] = cookies[:question_num].to_i - 1
  end

  def edit
    @editing = true
    @survey = @question.survey
  end

  def create
  end

  def update
    if @question.update(question_params)
      redirect_to edit_survey_path @question.survey
    else
      render :edit
    end
  end

  def destroy
    @question_id = @question.id
    @question_num = @question.get_num
    @question.destroy if @question
  end

  def set_type
    @type = params[:type]
    cookies["question_#{@question_num}_selection_num"] = 1
  end

  def read_more
    @question = SurveyQuestion.find params[:id]
    @survey = @question.survey
    @read_more = true
  end

  private

  def set_question
    @question = SurveyQuestion.find params[:id]
  end

  def set_question_num
    @question_num = params[:question_num]
  end

  def set_survey
    @survey = Survey.find_by_id params[:id]
  end

  def surveys
    @surveying = true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    params.require(:survey_question).permit(:body, :question_type)
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
