module Admin
  class UsersController < BaseController
    load_and_authorize_resource

    def index
      @users = @users.order(:updated_at => :desc).page(params[:page])
    end

    def show
    end

    def edit
    end

    def update
      if @user.update_attributes user_params
        flash[:success] = 'Your changes have been saved!'
        redirect_to admin_users_path
      else
        flash.now[:error] = 'Your changes could not be saved!'
        render 'edit'
      end
    end

    def destroy
      if @user.destroy
        flash[:success] = "The user has been deleted."
      else
        flash[:error] = "The user could not be deleted."
      end
      redirect_to :back
    end

    def become
      sign_in :user, @user
      flash[:success] = "Signed in as #{@user.name}."
      redirect_to root_path
    end

    private
    def user_params
      params.require(:user).permit(:email, :first_name, :role)
    end

  end
end
