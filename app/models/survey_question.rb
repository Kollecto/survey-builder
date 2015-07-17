class SurveyQuestion < ActiveRecord::Base

  serialize :data
  belongs_to :survey_iteration

end
