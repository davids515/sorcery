require 'rails_helper'

feature 'User Logs Out' do
  scenario 'Logs out' do
    user = FactoryGirl.create(:jack_sparrow)
    user.activate!
    sign_in_with('jack.sparrow@test.com', 'password')

    click_link 'Log Out'

    expect(page).to have_text('Logged out')
    expect(current_path).to eq(login_path)
  end
end
