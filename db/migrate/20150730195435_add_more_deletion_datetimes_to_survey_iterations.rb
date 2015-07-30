class AddMoreDeletionDatetimesToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :deletion_queued_at, :datetime
    add_column :survey_iterations, :deletion_started_at, :datetime
    add_column :survey_iterations, :deletion_failed_at, :datetime
  end
end
