class AddPreviousAndParentQuestionsToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :previous_question_id, :integer
    add_column :survey_questions, :parent_question_id, :integer
  end
end
