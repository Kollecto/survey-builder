class AddWorksheetHeaderRowToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :worksheet_header_row, :text
  end
end
