module SurveyQuestionsHelper
  def survey_question_section_type question
    if question.grid
      :grid
    else
      case question.question_type.to_sym
      when :open_ended, :open_ended_paragraph
        :open_ended
      else
        question.question_type.to_sym
      end
    end
  end

  def survey_question_filter_options
    options = [['Choose a question to filter by', nil]]
    for question in @survey.questions
      options << [snip_survey_txt(question.body.squish), question.id]
    end
    options
  end

  def survey_question_read_more_link question, read_more=nil
    link_to "Read more", survey_question_read_more_path(question.id), remote: true, class: "survey_interactive_link" \
      if question.body.to_s.size > SurveyQuestion::READ_MORE_MIN and not read_more
  end

  def show_some_or_all_questions survey
    unless @showing
      survey.questions.first SurveyQuestion::SUMMARY_MAX
    else
      survey.questions
    end
  end

  def active_question_type_link this_links_type
    case @type
    when 'checkbox'
      if this_links_type.eql? :checkbox
        ' '
      else
        'surveys_link '
      end
    when 'radio_button'
      if this_links_type.eql? :radio_button
        ' '
      else
        'surveys_link '
      end
    when 'open_ended_paragraph'
      if this_links_type.eql? :open_ended_paragraph
        ' '
      else
        'surveys_link '
      end
    else
      if this_links_type.eql? :open_ended
        ' '
      else
        'surveys_link '
      end
    end
  end
end
