class SurveysController < ApplicationController
  before_action :surveys
  before_action :invite_only, except: [:take, :complete, :thank_you, :create, :update, :destroy, :edit]
  before_action :set_survey, only: [:results, :complete, :take, :edit, :show, :update, :destroy, :read_more, :show_modal, :open_menu, :close_menu]
  before_action :secure_survey, only: [:update, :destroy, :edit]
  before_action :new_survey, only: [:index, :new, :show_survey_form]
  before_action :set_question_num, only: [:add_selection, :new_grid, :add_row, :remove_selection_field, :remove_selection_row_field]
  before_action :set_comments, only: [:show_modal, :show]

  def open_menu
    @showing = params[:showing]
  end

  def read_more
    @read_more = true
  end

  def complete
    # deletes page number you're at to be ready for next survey
    cookies.delete(:take_survey_page_num)
    if @survey
      @result = @survey.survey_results.new
      question_num = 1
      for question in @survey.questions
        if @result.save
          # skips this part if grid question
          unless question.grid
            case question.question_type
            when 'checkbox'
              selection_num = 1; selected = []
              for selection in question.survey_selections
                if params["question_#{question_num}_selection_#{selection_num}"]
                  # accounts for if Other option is chosen
                  if selection.other
                    selected << "Other: #{params["question_#{question_num}_selection_#{selection_num}_other"]}"
                    @other_selected = true
                  else
                    selected << selection.body
                  end
                end
                selection_num += 1
              end
              @result.survey_answers.create body: selected.to_s, question_body: question.body, survey_question_id: question.id, other: @other_selected
            when 'radio_button'
              if params["question_#{question_num}_selection"]
                answer = @result.survey_answers.new body: question.get_selection_by_num(params["question_#{question_num}_selection"]).body,
                  question_body: question.body, survey_question_id: question.id
                # accounts for if Other option is chosen
                if question.get_selection_by_num(params["question_#{question_num}_selection"]).other
                  answer.body = "Other: #{params["question_#{question_num}_selection_#{params["question_#{question_num}_selection"]}_other"]}"
                  answer.other = true
                end
                answer.save
              end
            else
              @result.survey_answers.create body: params["answer_#{question_num}"], question_body: question.body, survey_question_id: question.id
            end
          else
            # saves answers for grid questions
            if question.grid
              row_num = 1; selected = []
              for row in question.rows
                col_num = 1; selected_col = []
                for col in question.columns
                  if params["question_#{question_num}_row_#{row_num}_selection_#{col_num}"] \
                    or (question.question_type.eql? 'radio_button' and params["question_#{question_num}_row_#{row_num}_selection"] \
                      and params["question_#{question_num}_row_#{row_num}_selection"].to_i.eql? col_num)
                    selected_col << col.body
                  end
                col_num += 1; end
                selected << [row.body, selected_col] unless selected_col.empty?
              row_num += 1; end
              @result.survey_answers.create body: selected.to_s, question_body: question.body, survey_question_id: question.id
            end
          end
        end
      question_num += 1; end
    end
    if invited?
      redirect_to survey_results_path(@survey)
    else
      redirect_to survey_thank_you_path
    end
  end

  def take
    cookies.delete(:take_survey_page_num)
    @questions = @survey.questions
    @taking_survey = @show_banner = true
    @page_size = 5
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.user_id = current_user.id
    if @survey.save
      build_survey
      redirect_to @survey
    else
      redirect_to surveys_path
    end
  end

  def update
    if @survey.update(survey_params)
      build_survey
      redirect_to @survey
    else
      render :edit
    end
  end

  def destroy
    @survey.destroy
    redirect_to surveys_path unless params[:ajax_req].eql? 'true'
  end

  def index
    @surveys = Survey.all.reverse
    @surveys_index = @show_banner = @no_vertical_spacer = true
  end

  def edit
    @editing = true
    cookies[:question_num] = @survey.questions.size
  end

  def show
    @showing = true
  end

  private

  def set_comments
    @showing = true # works for both show and show_modal
    @comment = Comment.new
    @comments = @survey.comments
  end

  def build_survey
    # gets first question changed or added
    question_num = get_first_question_num
    # skip is turned off at start
    skip_to = 0
    begin
      # skips iterations until the next added or changed question
      if skip_to > question_num
        question_num += 1
        next
      else
        skip_to = 0
      end
      @question = @survey.questions.new body: params["question_#{question_num}"],
        question_type: params["question_#{question_num}_type"], grid: params["question_#{question_num}_grid"]
      # checks if this question is having selections added
      editing_this_question = params["question_#{question_num}_editing"].present?
      if editing_this_question or @question.save
        # finds question by question_num if questions not being added but just having selections added
        @question = @survey.get_question_by_num question_num if editing_this_question
        # saves survey selections (columns)
        selection_num = get_first_selection_num question_num
        begin
          @selection = @question.survey_selections.create body: params["question_#{question_num}_selection_#{selection_num}"]
          selection_num += 1
        end while params["question_#{question_num}_selection_#{selection_num}"].present?
        # saves survey selections (rows)
        row_num = get_first_row_num question_num
        begin
          @row = @question.survey_selections.create body: params["question_#{question_num}_row_#{row_num}"], row: true
          row_num += 1
        end while params["question_#{question_num}_row_#{row_num}"].present?
      end
      # adds other option for selections
      @question.add_other params["question_#{question_num}_other"]
      question_num += 1
      # finds next question to skip to if the very next one wasn't changed
      unless params["question_#{question_num}"].present? or params["question_#{question_num}_editing"].present?
        if get_first_question_num(question_num) > question_num
          skip_to = get_first_question_num question_num
        end
      end
    # goes to next iteration of loop if params present or more questions below to skip to
    end while params["question_#{question_num}"].present? or params["question_#{question_num}_editing"].present? or skip_to > 0
  end

  def get_first_question_num question_num=nil
    # gets the next question input if any
    question_num ||= 1
    until params["question_#{question_num}"].present? or params["question_#{question_num}_editing"].present? or question_num > 50
      question_num += 1
    end
    return question_num
  end

  def get_first_selection_num question_num
    selection_num = 1
    until params["question_#{question_num}_selection_#{selection_num}"].present? or selection_num > 50
      selection_num += 1
    end
    return selection_num
  end

  def get_first_row_num question_num
    row_num = 1
    until params["question_#{question_num}_row_#{row_num}"].present? or row_num > 50
      row_num += 1
    end
    return row_num
  end

  def new_survey
    @survey = Survey.new
    cookies[:question_num] = 1
  end

  def set_survey
    if params[:token]
      @survey = Survey.find_by_unique_token(params[:token])
      @survey ||= Survey.find_by_id(params[:token]) if invited? # only allow by id if invited
    elsif invited? # for safety
      @survey = Survey.find_by_unique_token(params[:id])
      @survey ||= Survey.find_by_id(params[:id])
    end
  end

  def surveys
    @surveying = true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def survey_params
    params.require(:survey).permit(:title, :body, :image)
  end

  def secure_survey
    unless current_user and @survey.user_id.eql? current_user.id or admin?
      redirect_to lacks_permission_path
    end
  end

  def admin_only
    unless admin?
      redirect_to lacks_permission_path
    end
  end

  def invite_only
    unless invited? or current_user
      redirect_to sessions_new_path
    end
  end

  def current_user_only
    unless current_user
      redirect_to sessions_new_path
    end
  end
end
