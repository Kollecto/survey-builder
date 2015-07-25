module Admin
  class SurveyQuestionsController < BaseController
    load_and_authorize_resource :except => :index
    before_filter :fetch_page
    before_filter :fetch_iteration

    def index
      @survey_questions = case @by
                          when 'iteration' then @iteration.survey_questions
                          when 'page' then @page.survey_questions
                          else SurveyQuestion.accessible_by current_ability
                          end
      @survey_questions = @survey_questions.order(:updated_at => :desc)
                                           .page(params[:page])
    end

    def show
    end

    private
    def fetch_iteration
      @iteration = if params.key? :survey_iteration_id
                     @by ||= 'iteration'
                     SurveyIteration.find params[:survey_iteration_id]
                   elsif @survey_question.present?
                     @survey_question.survey_iteration
                   elsif @page.present?
                     @page.survey_iteration
                   end
    end
    def fetch_page
      @page = if params.key? :survey_page_id
                @by ||= 'page'
                SurveyPage.find params[:survey_page_id]
              elsif @survey_question.present?
                @survey_question.survey_page
              end
    end
    def survey_question_params
      params.require(:survey_question).permit :title, :description
    end

  end
end
