class DeleteSurveyIterationJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    iteration.delete_from_survey_gizmo! if iteration.published_to_sg?
    iteration.send :update_columns, deletion_started_at: Time.now,
                                    deletion_failed_at: nil
    iteration.destroy!
  rescue => e
    iteration.send :update_column, :deletion_failed_at, Time.now
    raise e
  end
end
