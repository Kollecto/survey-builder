class CreateSurveyIterations < ActiveRecord::Migration
  def change
    create_table :survey_iterations do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
