class AddSgSurveyIdToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :sg_survey_id, :string
  end
end
