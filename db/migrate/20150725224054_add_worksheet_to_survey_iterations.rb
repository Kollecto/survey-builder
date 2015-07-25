class AddWorksheetToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :google_spreadsheet_id, :string
    add_column :survey_iterations, :google_worksheet_url, :string
  end
end
