require 'rails_helper'

feature 'Dashboard' do
  scenario "can't access to dashboard if not logged in" do
    visit dashboard_path

    expect(current_path).to eq(login_path)
    expect(page).to have_text('Please login first')
  end
end
