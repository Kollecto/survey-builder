class CreateSurveyPages < ActiveRecord::Migration
  def up
    create_table :survey_pages do |t|
      t.string :title
      t.text :description
      t.string :sg_page_id
      t.integer :survey_iteration_id
      t.text :metadata

      t.timestamps null: false
    end
    add_column    :survey_questions, :survey_page_id, :integer
  end
  def down
    drop_table :survey_pages
    remove_column :survey_questions, :survey_page_id
  end
end
