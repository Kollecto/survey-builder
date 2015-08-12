module Admin
  class SurveySubmissionsController < BaseController
    load_and_authorize_resource :except => [:index]
    before_filter :fetch_iteration

    def index
      @survey_submissions = case @by
                            when 'iteration' then @iteration.survey_submissions
                            else SurveySubmission.accessible_by current_ability
                            end
      @survey_submissions = @survey_submissions.order(updated_at: :desc)
                                               .page(params[:page])
    end

    def show
    end

    def destroy
      if @survey_submission.destroy
        flash[:info] = 'The submission has been deleted.'
      else
        flash[:error] = 'The submission could not be deleted!'
      end
      redirect_to admin_survey_submissions_path
    end

    private
    def fetch_iteration
      @iteration = if params.key? :survey_iteration_id
                     @by ||= 'iteration'
                     SurveyIteration.find params[:survey_iteration_id]
                   elsif @survey_submission.present?
                     @survey_submission.survey_iteration
                   end
    end

  end
end
