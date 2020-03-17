class SurveySelectionsController < ApplicationController
  before_action :surveys
  before_action :invite_only
  before_action :set_selection, only: [:edit, :update, :destroy]
  before_action :set_question_num, only: [:add, :new_grid, :add_row, :remove_field, :remove_row_field]

  def edit
    @editing = true
    @survey = @selection.question.survey
  end

  def update
    if @selection.update(selection_params)
      redirect_to edit_survey_path @selection.question.survey
    else
      render :edit
    end
  end

  def destroy
    @selection_id = @selection.id
    @selection.destroy if @selection
  end

  def remove_field
    @editing = params[:editing].present?
    @other = params[:other].present?
    @selection_num = params[:selection_num]
    cookies["question_#{@question_num}_selection_num"] = cookies["question_#{@question_num}_selection_num"].to_i - 1 unless @other
  end

  def remove_row_field
    @row_num = params[:row_num]
    cookies["question_#{@question_num}_row_num"] = cookies["question_#{@question_num}_row_num"].to_i - 1
  end

  def add
    @selection_num = params[:selection_num]
    @type = params[:type]
    @editing = params[:editing].present?
    @other = params[:other].present?
  end

  def new_grid
    cookies["question_#{@question_num}_row_num"] = 1
  end

  def add_row
    cookies["question_#{@question_num}_row_num"] = cookies["question_#{@question_num}_row_num"].to_i + 1
    @editing = params[:editing].present?
  end

  private

  def selection_params
    params.require(:survey_selection).permit(:body)
  end

  def set_selection
    @selection = SurveySelection.find params[:id]
  end

  def set_question_num
    @question_num = params[:question_num]
  end

  def surveys
    @surveying = true
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
