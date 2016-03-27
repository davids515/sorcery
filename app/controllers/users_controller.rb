class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, alert: 'You will receive an email within the next few minutes with a link to activate your account.'
    else
      render action: :new
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      redirect_to(login_path, notice: 'Your account was successfully activated.')
    else
      redirect_to login_path, notice: 'Please login.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
