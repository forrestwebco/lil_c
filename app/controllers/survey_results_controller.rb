class SurveyResultsController < ApplicationController
  before_action :set_survey, only: [:index, :filter_by, :sort_by, :reset_filter, :show_grid_filter, :remove_grid_filter, :destroy]
  before_action :reset_sort_and_filter_options, only: [:index, :reset_filter]
  before_action :admin_only
  before_action :surveys

  def destroy
    @result = SurveyResult.find params[:id]
    @result.destroy
  end

  def index
    @results = @survey.survey_results
  end

  def filter_by
    @_results = @survey.survey_results
    @results = []
    for result in @_results
      for answer in result.survey_answers
        # sets up grid selections to see if it matches grid filter input if any
        grid_selections = []; if answer.survey_question.grid
          for param in params
            if param.include? "grid_question_#{answer.survey_question.id}_"
              grid_selections = answer.survey_question.make_grid_selections grid_selections, params, param
            end
          end
        end
        # sets up checkbox selections to see if it matches checkbox filter input if any
        checkbox_selections = []; if answer.survey_question.question_type.eql? 'checkbox' and not answer.survey_question.grid
          for param in params
            if param.include? "question_#{answer.survey_question.id}_" and params["question_#{answer.survey_question.id}_#{param.split("_").last}"].present?
              checkbox_selections << param.split("_").last

              puts "\n\n\n#{checkbox_selections}\n\n\n"
            end
          end
        end
        # if there was any filter input for this answer's question
        if params[answer.survey_question.body.squish].present? or checkbox_selections.present? or grid_selections.present?
          # if the filter input matches this answer, also accounts for Other option being chosen
          if params[answer.survey_question.body.squish].eql? answer.get_body_with_other \
            or (checkbox_selections.present? and eval(answer.get_body_with_other).eql? checkbox_selections) \
            or (grid_selections.present? and eval(answer.body).eql? grid_selections)
            # append result unless its already been added
            @results << result unless @results.include? result
          # remove whole result if any input doesn't match its answer
          else
            @results.delete result if @results.include? result # may be redundant, may remove soon
            break
          end
        end
      end
    end

    # uses and sorts by sorted option parameters if any
    if cookies[:sorted_results_option].present? and false # turned off for now
      order = eval(cookies[:sorted_results_option])[:order]
      question_body = eval(cookies[:sorted_results_option])[:question_body]

      puts "\n\n\nusing saved result sort order: #{order}, #{question_body}\n\n\n"

      @results.sort_by do |result|
        answer = result.survey_answers.find_by_question_body(question_body)
        if answer.survey_question.question_type.eql? "checkbox"
          eval(answer.body).first
        else
          answer.body
        end
      end
      @results.reverse! if order.present? and order.eql? 'down'
    end

    # saves option parameters for sorted results to be used in conjunction with filter
    result_ids = []; @results.each { |result| result_ids << result.id }
    cookies[:filtered_result_ids] = result_ids.to_s

    puts "\n\n\nsaving result ids: #{result_ids}\n\n\n"
  end # end filter_by

  def sort_by
    @results = if params[:order].present?
      # uses filtered result ids if any
      results = if cookies[:filtered_result_ids].present?

        puts "\n\n\nusing saved result ids: #{eval(cookies[:filtered_result_ids])}\n\n\n"

        _results = []; eval(cookies[:filtered_result_ids]).each do |id|
          _results << SurveyResult.find(id)
        end
        _results
      else
        @survey.survey_results
      end
      # sorts by order for question
      results.sort_by do |result|
        answer = result.survey_answers.find_by_question_body(params[:question_body])
        if answer and answer.survey_question.question_type.eql? "checkbox"
          eval(answer.body).first
        elsif answer
          answer.body
        else
          '' # sorts by empty string if no answer yet
        end
      end
    else
      @survey.survey_results
    end
    @results.reverse! if params[:order].present? and params[:order].eql? 'down'
    # saves option parameters for sorted results to be used in conjunction with filter
    cookies[:sorted_results_option] = {order: params[:order], question_body: params[:question_body]}.to_s

    puts "\n\n\nsaving result sort order: #{params[:order]}, #{params[:question_body]}\n\n\n"
  end

  def read_more
    @answer = SurveyAnswer.find_by_id params[:id]
    @result_num = params[:result_num]
    @read_more = true
  end

  def remove_filter_field
    @question = SurveyQuestion.find_by_id params[:id]
  end

  def reset_filter
    @results = @survey.survey_results
  end

  private

  def reset_sort_and_filter_options
    cookies.delete :filtered_result_ids
    cookies.delete :sorted_results_option
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

  def admin_only
    unless admin?
      redirect_to lacks_permission_path
    end
  end

  def invite_only
    unless invited?
      redirect_to sessions_new_path
    end
  end
end
