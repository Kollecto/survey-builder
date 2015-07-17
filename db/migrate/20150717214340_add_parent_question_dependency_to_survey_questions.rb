class AddParentQuestionDependencyToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :parent_question_dependency, :string
  end
end
