class AddDeletionDatetimesToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :delete_from_sg_queued_at, :datetime
    add_column :survey_iterations, :delete_from_sg_started_at, :datetime
    add_column :survey_iterations, :delete_from_sg_completed_at, :datetime
    add_column :survey_iterations, :delete_from_sg_jid, :string
  end
end
