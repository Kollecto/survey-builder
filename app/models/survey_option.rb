class SurveyOption < ActiveRecord::Base

  serialize :metadata
  belongs_to :survey_question
  belongs_to :survey_page
  belongs_to :survey_iteration

  def sg_option
    return unless self.sg_option_id.present?
    SurveyGizmo::API::Option.first id: self.sg_option_id,
      question_id: self.survey_question.sg_question_id,
      page_id: self.survey_page.sg_page_id,
      survey_id: self.survey_iteration.sg_survey_id
  end
  def sg_option_params
    {
      :survey_id => self.survey_iteration.sg_survey_id,
      :page_id => self.survey_page.sg_page_id,
      :question_id => self.survey_question.sg_question_id,
      :title => self.title,
      :value => self.reporting_value
    }.dup.merge(metadata.present? ? metadata[:sg_params] || {} : {})
  end
  def export_to_survey_gizmo!
    option = SurveyGizmo::API::Option.create sg_option_params
    self.sg_option_id = option.id
  end

end
