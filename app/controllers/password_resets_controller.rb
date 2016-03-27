class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    @user.deliver_reset_password_instructions! if @user

    redirect_to(login_path, notice: 'Instructions have been sent to your email.')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      return not_authenticated, alert: 'Invalid token'
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      return not_authenticated, alert: 'Invalid token'
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      redirect_to(login_path, notice: 'Password was successfully updated.')
    else
      render action: :edit
    end
  end
end
