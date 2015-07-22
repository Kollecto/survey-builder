class HomeController < ApplicationController

  def home
  end

  def google_auth_callback
    if params.key? :code
      code = params[:code]
      if SurveyIteration.do_google_auth_with_code! code
        flash[:success] = 'You\'ve successfully authenticated through Google!'
        return_to = session.delete(:return_to) || root_path
        redirect_to return_to
      else
        flash[:error] = 'Google authentication failed!'
        redirect_to root_path
      end
    else
      render :text => 'An authorization code is required.'
    end
  end

end
