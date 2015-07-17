class CreateSurveyOptions < ActiveRecord::Migration
  def change
    create_table :survey_options do |t|
      t.string :title
      t.string :reporting_value
      t.text :metadata
      t.string :sg_option_id
      t.integer :survey_question_id
      t.integer :survey_page_id
      t.integer :survey_iteration_id

      t.timestamps null: false
    end
  end
end
