class AddGoogleWorksheetStuffToSurveyIterations < ActiveRecord::Migration
  def change
    add_column :survey_iterations, :google_worksheet_header_row_index, :integer, :default => 0
    add_column :survey_iterations, :google_worksheet_filtering_column_index, :integer
    add_column :survey_iterations, :google_worksheet_filtering_column_value, :string
    add_column :survey_iterations, :google_worksheet_art_attributes_start_column_index, :integer
    add_column :survey_iterations, :google_worksheet_art_attributes_end_column_index, :integer
  end
end
