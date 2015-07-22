module SurveyPageNavigation
  extend ActiveSupport::Concern

  def id_of_this_page
    self.class.name == 'SurveyPage' ? self.id : self.current_page_id
  end
  def pages_in_iteration
    if self.class.name == 'SurveyPage' then self.survey_iteration.survey_pages
    else self.survey_pages end
  end
  def prev_page_id(from=nil)
    from ||= id_of_this_page
    page_ids = pages_in_iteration.pluck(:id)
    prev_page_index = page_ids.index(from) - 1
    return if prev_page_index == -1
    page_ids[prev_page_index]
  end
  def prev_page
    return nil if (pid = prev_page_id).nil?
    SurveyPage.find pid
  end
  def next_page_id(from=nil)
    from ||= id_of_this_page
    page_ids = pages_in_iteration.pluck(:id)
    next_page_index = page_ids.index(from) + 1
    return if next_page_index == page_ids.length
    page_ids[next_page_index]
  end
  def next_page
    return nil if (pid = next_page_id).nil?
    SurveyPage.find pid
  end

end
