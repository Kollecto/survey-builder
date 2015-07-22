class CreateSurveySubmissions < ActiveRecord::Migration
  def change
    create_table :survey_submissions do |t|
      t.integer :user_id
      t.text :submission
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :survey_iteration_id
      t.integer :current_page_id

      t.timestamps null: false
    end
  end
end
