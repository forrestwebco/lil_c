module SurveysHelper
  def survey_read_more_link survey, read_more=nil
    link_to "Read more", survey_read_more_path(id: survey.id),
      remote: true, class: "stacked_shared_item_edit_link" if survey.body.size > Survey::READ_MORE_MIN and not read_more
  end

  def snip_survey_txt txt, read_more=nil, small=nil
    unless read_more
      Survey.snip_txt txt, small
    else
      txt
    end
  end
end
