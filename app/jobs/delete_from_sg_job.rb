class DeleteFromSgJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    iteration.delete_from_survey_gizmo!
  end

end
