require 'rails_helper'

feature 'User logs In' do
  scenario 'Responds to login path' do
    visit login_path

    expect(current_path).to eq(login_path)
    expect(page).to have_selector('h1', text: 'Log In')
  end

  scenario 'Fails without email' do
    visit login_path

    fill_in 'user_password', with: 'password'
    click_button 'Log In'

    expect(page).to have_text('Invalid user/email combination')
  end

  scenario 'Fails with and invalid email' do
    visit login_path

    fill_in 'user_email', with: 'whatever'
    fill_in 'user_password', with: 'password'
    click_button 'Log In'

    expect(page).to have_text('Invalid user/email combination')
  end

  scenario 'Fails without password' do
    visit login_path

    fill_in 'user_email', with: 'test@test.com'
    click_button 'Log In'

    expect(page).to have_text('Invalid user/email combination')
  end

  scenario 'Logs in with a valid user and password' do
    user = FactoryGirl.create(:jack_sparrow)
    user.activate!
    # TODO: create a fixture

    sign_in_with('jack.sparrow@test.com', 'password')

    expect(page).to have_text('Dashboard')
    expect(current_path).to eq(dashboard_path)
  end
end
