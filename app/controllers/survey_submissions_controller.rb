class SurveySubmissionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:start]
  load_and_authorize_resource

  def start
    if user_signed_in?
      if ( not_completed = current_user.survey_submissions.not_completed ).any?
        resume_a_submission not_completed.first
      else start_a_submission end and return
    elsif params[:email] && params[:first_name] && params[:taste]
      if User.exists? email: params[:email]
        redirect_to new_user_session_path(email: params[:email])
      else
        user = User.invite!(
          email: params[:email],
          first_name: params[:first_name],
          taste_category_name: params[:taste]) {|u| u.skip_invitation = true }
        sign_in user
        start_a_submission and return
      end
    else
      redirect_to new_user_registration_path
    end
  end

  def take_survey
    if params.key?(:submission)
      @survey_submission.update_submission! params[:submission]
    end
    if params.key?(:survey_page)
      @survey_page = @survey_submission.survey_pages.find(params[:survey_page])
    else
      @survey_page = @survey_submission.current_page
    end
    @prev_page = @survey_page.prev_page
    @next_page = @survey_page.next_page
  end

  private
  def start_a_submission
    submission = SurveySubmission.create :user => current_user
    resume_a_submission submission
  end
  def resume_a_submission(s); redirect_to take_survey_submission_path(s); end

end
