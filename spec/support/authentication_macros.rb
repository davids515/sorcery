module AuthenticationMacros
  def sign_in_with(email, password)
    visit login_path

    fill_in 'user_email', with: email
    fill_in 'user_password', with: password

    click_button 'Log In'
  end

  def sign_up_with(email, password)
    visit registration_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password

    click_button 'Register'
  end
end
