module Admin
  class SurveyIterationsController < BaseController
    load_and_authorize_resource
    before_filter :authenticate_with_google!, :only => [:new]

    def new
    end

    def create
      @survey_iteration.creator = current_user
      @survey_iteration.save
      respond_with :admin, @survey_iteration
    end

    def index
      @survey_iterations = @survey_iterations.order( updated_at: :desc )
                                             .page(  params[:page]  )
    end

    def show
      if @survey_iteration.preparing_to_import_from_google?
        authenticate_with_google!; end
      @pages = @survey_iteration.survey_pages.order(updated_at: :desc).limit(5)
      @questions = @survey_iteration.survey_questions
                   .order(updated_at: :desc).limit(5)
    end

    def edit
    end

    def update
      @survey_iteration.update_attributes survey_iteration_params
      respond_with :admin, @survey_iteration
    end

    def destroy
      DeleteSurveyIterationJob.perform_later @survey_iteration
      flash[:info] = 'Your survey iteration will be deleted in the background.'
      redirect_to admin_survey_iterations_path
    end

    def import_from_gd
      if @survey_iteration.begin_import_from_google!
        flash[:success] = 'Your iteration is queued for imported from Google Drive!'
      else
        flash[:error] = 'Your iteration could not be queued for import!'
      end
      redirect_to :back
    end

    def reimport_from_gd
      if @survey_iteration.begin_reimport_from_google!
        flash[:success] = 'Your iteration is queued for reimport from Google Drive!'
      else
        flash[:error] = 'Your iteration could not be queued for reimport!'
      end
      redirect_to :back
    end

    def publish_to_sg
      if @survey_iteration.publish_to_sg!
        flash[:success] = 'Your iteration is queued for publish to Survey Gizmo!'
      else
        flash[:error] = 'Your iteration could not be queued for publish to Survey Gizmo!'
      end
      redirect_to :back
    end

    def cancel_publish_to_sg
      if @survey_iteration.cancel_publish_to_sg!
        flash[:success] = 'Your publishing job is being cancelled.'
      else
        flash[:error] = 'The job could not be cancelled!'
      end
      redirect_to :back
    end

    def delete_from_sg
      if @survey_iteration.delete_from_sg!
        flash[:success] = 'Your iteration is queued for deletion from Survey Gizmo!'
      else
        flash[:error] = 'Your iteration could not be queued for deletion from Survey Gizmo!'
      end
      redirect_to :back
    end

    private
    def survey_iteration_params
      params.require(:survey_iteration).permit :title,
        :google_worksheet_params,
        :google_worksheet_header_row_index,
        :google_worksheet_filtering_column_index,
        :google_worksheet_filtering_column_value,
        :google_worksheet_art_attributes_start_column_index,
        :google_worksheet_art_attributes_end_column_index
    end

  end
end
