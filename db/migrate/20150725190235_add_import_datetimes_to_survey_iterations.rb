class AddImportDatetimesToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :import_from_google_queued_at, :datetime
    add_column :survey_iterations, :import_from_google_started_at, :datetime
    add_column :survey_iterations, :import_from_google_completed_at, :datetime
    add_column :survey_iterations, :import_from_google_jid, :string
  end
end
