class PublishToSgJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    return if cancelled?
    puts "Publish job running!"
    iteration.export_to_survey_gizmo!
  end

  def cancelled?
    Sidekiq.redis{|c| c.exists("cancelled-#{job_id}") }
  end
  def self.cancel!(jid)
    Sidekiq.redis{|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

end
