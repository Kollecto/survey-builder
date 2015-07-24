class AddPublishedToSgAtToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :published_to_sg_at, :datetime
  end
end
