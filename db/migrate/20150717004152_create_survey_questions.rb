class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.text :metadata
      t.integer :survey_iteration_id

      t.timestamps null: false
    end
  end
end
