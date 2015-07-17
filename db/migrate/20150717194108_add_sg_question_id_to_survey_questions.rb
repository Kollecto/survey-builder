class AddSgQuestionIdToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :sg_question_id, :string
  end
end
