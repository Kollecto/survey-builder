require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, :if => :devise_controller?
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
  rescue_from User::GoogleAuthRequiredError do
    session[:return_to] = request.url
    auth_url = User.build_google_auth_obj.authorization_uri.to_s
    puts auth_url
    redirect_to auth_url
  end

  protected
  def configure_permitted_parameters
    [:first_name, :taste_category_name].each do |pm|
      devise_parameter_sanitizer.for(:sign_up) << pm
      devise_parameter_sanitizer.for(:account_update) << pm
      devise_parameter_sanitizer.for(:accept_invitation) << pm
    end
  end
  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      flash[:error] = 'You must be an admin to access to access this area!'
      redirect_to root_path
    end
  end
  def authenticate_with_google!
    authenticate_user!
    unless current_user.google_auth_active?
      raise User::GoogleAuthRequiredError.new
    end
  end

end
