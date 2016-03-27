require 'rails_helper'

feature 'User Registration' do

  scenario 'responds to register path' do
    visit registration_path

    expect(current_path).to eq(registration_path)
    expect(page).to have_selector('h1', text: 'Registration')
  end

  feature 'Form validations' do
    before(:each) do
      visit registration_path
    end

    scenario 'fails without an e-mail' do
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Register'

      expect(page).to have_selector('div.user_email.has-error span.help-block', "can't be blank")
    end

    scenario 'fails without a password' do
      fill_in 'user_email', with: 'john.rambo@test.com'
      click_button 'Register'

      expect(page).to have_selector('div.user_password.has-error span.help-block', "is too short (minimum is 3 characters)")
    end

    scenario 'fails without a password confirmation' do
      fill_in 'user_email', with: 'john.rambo@test.com'
      fill_in 'user_password', with: 'password'
      click_button 'Register'

      expect(page).to have_selector('div.user_password_confirmation.has-error span.help-block', "doesn't match Password")
    end

    scenario "fails if confirmation password doesn't match the password" do
      fill_in 'user_email', with: 'john.rambo@test.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'paword'
      click_button 'Register'

      expect(page).to have_selector('div.user_password_confirmation.has-error span.help-block', "doesn't match Password")
    end
  end

  feature 'User exists' do
    scenario "fails if the email already exists" do
      user = FactoryGirl.create(:jack_sparrow)
      user.activate!
      visit registration_path

      fill_in 'user_email', with: 'jack.sparrow@test.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Register'

      expect(current_path).to eq(registration_path)
      expect(page).to have_selector('div.user_email.has-error span.help-block', "has already been taken")
    end

    scenario "fails if the email already exists, even if the account wasn't activated" do
      user = FactoryGirl.create(:jack_sparrow)
      visit registration_path

      fill_in 'user_email', with: 'jack.sparrow@test.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Register'

      expect(current_path).to eq(registration_path)
      expect(page).to have_selector('div.user_email.has-error span.help-block', "has already been taken")
    end
  end

  feature 'Registration' do
    scenario 'registers with valid data' do
      visit registration_path

      fill_in 'user_email', with: 'jack.sparrow@test.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Register'

      expect(current_path).to eq(login_path)
      expect(page).to have_content("You will receive an email within the next few minutes with a link to activate your account.")
    end

    scenario 'sends an e-mail with a confirmation link' do
      expect {
        sign_up_with 'jack.sparrow@test.com', 'password'
      }.to change {
        ActionMailer::Base.deliveries.size
      }.by(1)

      user = User.where(email: 'jack.sparrow@test.com').first

      welcome_email = ActionMailer::Base.deliveries.last

      expect(welcome_email.subject).to eq('Account confirmation')
      expect(welcome_email.to[0]).to eq('jack.sparrow@test.com')

      # a better test would test all text
      expect(welcome_email.body.to_s).to include('Thank you for registering')

      # the expected confirmation url
      expect(welcome_email.body.to_s).to include(activate_user_path(user.activation_token))
    end

    scenario 'activates the account if the user follows a valid activation link' do
      user = FactoryGirl.create(:jack_sparrow)
      visit activate_user_path(user.activation_token)

      expect(page).to have_content('Your account was successfully activated.')
    end

    scenario "a 'Please login.' message will be displayed if an active user follows the activation link" do
      user = FactoryGirl.create(:jack_sparrow)
      url = activate_user_path(user.activation_token)
      user.activate!

      visit url

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Please login.')
    end

    scenario "a 'Please login.' message will be displayed if the activation token is unknown" do
      visit activate_user_path('abcdefg')

      expect(current_path).to eq(login_path)
      expect(page).to have_content('Please login.')
    end

    scenario 'sends a welcome e-mail after account confirmation' do
      user = FactoryGirl.create(:jack_sparrow)

      expect{
        visit activate_user_path(user.activation_token)
      }.to change{
        ActionMailer::Base.deliveries.size
      }.by(1)

      welcome_email = ActionMailer::Base.deliveries.last

      expect(welcome_email.subject).to include('Your account is now activated')
      expect(welcome_email.to[0]).to include('jack.sparrow@test.com')

      expect(welcome_email.body.to_s).to match(/Congratz/)
    end
  end
end
