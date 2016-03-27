class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      redirect_back_or_to(dashboard_path, notice: 'Login successful')
    else
      @user = User.new
      flash.now[:alert] = 'Invalid user/email combination'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: 'Logged out successfully.'
  end
end
