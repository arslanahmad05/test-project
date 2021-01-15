class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    email = ValidEmailService.new(params[:user]).call
    if email.present?
      @user = User.new(user_params)
      @user.email = email
      @user.save
    else
      flash[:alert] = "Please try another data"
    end
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :url)
  end
end
