class AddImportFromGoogleFailedAtToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :import_from_google_failed_at, :datetime
  end
end
