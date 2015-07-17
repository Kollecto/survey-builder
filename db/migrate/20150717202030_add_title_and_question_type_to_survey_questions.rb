class AddTitleAndQuestionTypeToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :title, :string
    add_column :survey_questions, :question_type, :string, :default => 'radio'
  end
end
