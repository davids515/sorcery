require 'rails_helper'

feature 'Recover Password' do

  feature 'Email unknown or invalid' do
    scenario 'e-mail is not sent, ' do
      visit new_password_reset_path

      click_on "Reset my password"

      expect(current_path).to eq(login_path)
    end

    scenario 'shows a success message' do
      visit new_password_reset_path

      click_on "Reset my password"

      expect(page).to have_text('Instructions have been sent to your email.')
    end
  end

  feature 'Email known' do
    before(:each) do
      @user = FactoryGirl.create(:jack_sparrow)
      visit new_password_reset_path
      fill_in :user_email, with: 'jack.sparrow@test.com'
    end

    scenario 'sends an e-mail to the user with a link to change the password' do
      expect {
        click_on 'Reset my password'
      }.to change {
        ActionMailer::Base.deliveries.size
      }.by(1)

      email = ActionMailer::Base.deliveries.last

      expect(email.subject).to eq('Reset your password')
      expect(email.to[0]).to eq('jack.sparrow@test.com')

      expect(email.body.to_s).to include('You have requested to reset your password')
      @user.reload
      expect(email.body.to_s).to include(edit_password_reset_path(@user.reset_password_token))
    end

    feature 'Form' do
      scenario 'show it when the user follows the change password link' do
        click_on 'Reset my password'
        @user.reload

        visit edit_password_reset_path(@user.reset_password_token)
        expect(current_path).to eq(edit_password_reset_path(@user.reset_password_token))
        expect(page).to have_selector('h1', 'Choose a new password')
      end

      scenario "it fails if the password doesn't mathe the password confirmation" do
        click_on 'Reset my password'
        @user.reload

        visit edit_password_reset_path(@user.reset_password_token)
        fill_in :user_password, with: 'abcd12345'
        fill_in :user_password_confirmation, with: 'abcd1234'

        click_on 'Update User'

        expect(page).to have_content("doesn't match Password")
      end

      scenario 'changes the password' do
        click_on 'Reset my password'
        @user.reload

        visit edit_password_reset_path(@user.reset_password_token)
        fill_in :user_password, with: 'abcd12345'
        fill_in :user_password_confirmation, with: 'abcd12345'

        crypted_password = @user.crypted_password

        click_on 'Update User'
        @user.reload

        expect(@user.crypted_password).to_not eq(crypted_password)
        expect(page).to have_content('Password was successfully updated')
      end
    end




  end
end
