module Admin
  class SurveyPagesController < BaseController
    load_and_authorize_resource :except => :index
    before_filter :fetch_iteration

    def new
    end

    def create
    end

    def index
      @survey_pages = case @by
                      when 'iteration' then @iteration.survey_pages
                      else SurveyPage.accessible_by current_ability
                      end
      @survey_pages = @survey_pages.order(:updated_at => :desc)
                                   .page(params[:page])
    end

    def show
    end

    def edit
    end

    def update
    end
    
    def destroy
    end

    private
    def fetch_iteration
      @iteration = if params.key? :survey_iteration_id
                     SurveyIteration.find params[:survey_iteration_id]
                   elsif @survey_page.present?
                     @survey_page.survey_iteration
                   end
    end
    def survey_page_params
      params.require(:survey_page).permit :title, :description
    end

  end
end
