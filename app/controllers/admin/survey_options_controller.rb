module Admin
  class SurveyOptionsController < BaseController
    load_and_authorize_resource :except => :index
    before_filter :fetch_question
    before_filter :fetch_page
    before_filter :fetch_iteration

    def index
      @survey_options = case @by
                        when 'iteration' then @iteration.survey_options
                        when 'page' then @page.survey_options
                        when 'question' then @question.survey_options
                        else SurveyOption.accessible_by current_ability
                        end
      @survey_options = @survey_options.order(:updated_at => :desc)
                                       .page(params[:page])
    end

    def show
    end

    private
    def fetch_iteration
      @iteration = if params.key? :survey_iteration_id
                     @by ||= 'iteration'
                     SurveyIteration.find params[:survey_iteration_id]
                   elsif @survey_option.present?
                     @survey_option.survey_iteration
                   elsif @question.present?
                     @question.survey_iteration
                   elsif @page.present?
                     @page.survey_iteration
                   end
    end
    def fetch_page
      @page = if params.key? :survey_page_id
                @by ||= 'page'
                SurveyPage.find params[:survey_page_id]
              elsif @survey_option.present?
                @survey_option.survey_page
              elsif @question.present?
                @question.survey_page
              end
    end
    def fetch_question
      @question = if params.key? :survey_question_id
                    @by ||= 'question'
                    SurveyQuestion.find params[:survey_question_id]
                  elsif @survey_option.present?
                    @survey_option.survey_question
                  end
    end
  end
end
