class ImportFromGoogleDriveJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    # Do something later
    iteration.import_questions_from_google!
  rescue => e
    iteration.mark_import_from_google_failed!
    raise e
  end

end
