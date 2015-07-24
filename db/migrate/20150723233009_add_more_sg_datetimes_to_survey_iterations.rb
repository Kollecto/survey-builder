class AddMoreSgDatetimesToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :publish_to_sg_started_at, :datetime
    add_column :survey_iterations, :publish_to_sg_queued_at, :datetime
  end
end
