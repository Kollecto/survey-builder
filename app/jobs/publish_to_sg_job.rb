class PublishToSgJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    puts "Publish job running!"
    iteration.export_to_survey_gizmo!
  end
end
