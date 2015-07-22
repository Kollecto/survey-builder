class RegistrationsController < Devise::RegistrationsController
  protected
  def after_sign_up_path_for(resource); start_path; end
end
