class UserMailer < ApplicationMailer
  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(user.activation_token, host: default_url_options[:host])
    mail(:to => user.email,
         :subject => "Account confirmation")
  end

  def activation_success_email(user)
    @user = user
    @url  = login_url(host: default_url_options[:host])
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(@user.reset_password_token)
    mail(:to => user.email,
         :subject => "Reset your password")
  end
end
