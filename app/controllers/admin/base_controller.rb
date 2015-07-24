module Admin
  class BaseController < ApplicationController
    before_filter :authenticate_admin!

    def dashboard
    end

  end
end
