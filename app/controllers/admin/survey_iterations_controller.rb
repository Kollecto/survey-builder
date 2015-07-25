module Admin
  class SurveyIterationsController < BaseController
    load_and_authorize_resource

    def new
      unless SurveyIteration.google_integration_activated?
        raise SurveyIteration::GoogleAuthRequiredError.new; end
    end

    def create
      @survey_iteration.save
      respond_with :admin, @survey_iteration
    end

    def index
      @survey_iterations = @survey_iterations.order( updated_at: :desc )
                                             .page(  params[:page]  )
    end

    def show
    end

    def edit
    end

    def update
    end

    def destroy
      @survey_iteration.destroy
      respond_with :admin, @survey_iteration
    end

    def publish_to_sg
      if @survey_iteration.publish_to_sg!
        flash[:success] = 'Your iteration has been published!'
      else
        flash[:error] = 'Your iteration could not be published!'
      end
      redirect_to :back
    end

    def cancel_publish_to_sg
      if @survey_iteration.cancel_publish_to_sg!
        flash[:success] = 'You\'ve cancelled a publishing job.'
      else
        flash[:error] = 'The job could not be cancelled!'
      end
      redirect_to :back
    end

    def delete_from_sg
      if @survey_iteration.delete_from_sg!
        flash[:success] = 'Your iteration has been deleted from Survey Gizmo!'
      else
        flash[:error] = 'Your iteration could not be deleted from Survey Gizmo!'
      end
      redirect_to :back
    end

    private
    def survey_iteration_params
      params.require(:survey_iteration).permit(:title)
    end

  end
end
