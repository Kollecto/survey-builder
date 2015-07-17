class SurveyQuestion < ActiveRecord::Base

  serialize :metadata
  belongs_to :survey_iteration

  def json_data; self.metadata.to_json; end

  def sg_question
    return unless self.sg_question_id.present?
    SurveyGizmo::API::Question.first id: self.sg_question_id
  end
  def sg_question_params
    {
      :survey_id => self.survey_iteration.sg_survey_id,
      :title => 'Test question'
    }
  end
  def export_to_survey_gizmo!
    question = SurveyGizmo::API::Question.create sg_question_params
    self.sg_question_id = question.id
  end

end
