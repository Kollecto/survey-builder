class AddImportDatetimeToSurveyPages < ActiveRecord::Migration
  def change
    add_column :survey_pages, :imported_from_google_at, :datetime
  end
end
