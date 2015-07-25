class AddCreatorIdToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :creator_id, :integer
  end
end
