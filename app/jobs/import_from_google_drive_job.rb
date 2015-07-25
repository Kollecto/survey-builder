class ImportFromGoogleDriveJob < ActiveJob::Base
  queue_as :default

  def perform(iteration)
    # Do something later
    iteration.import_questions_from_google!
  end
end
