class RegistrationsController < Devise::RegistrationsController
  protected
  def after_sign_up_path_for(resource); take_survey_path; end
end
