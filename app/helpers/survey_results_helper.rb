module SurveyResultsHelper
  def survey_result_read_more_link answer, read_more=nil, result_num=nil
    link_to "Read more", survey_result_read_more_path(id: answer.id, result_num: result_num),
      remote: true, class: "stacked_shared_item_edit_link" if answer.result_txt.size > SurveyResult::READ_MORE_MIN and not read_more
  end
end
