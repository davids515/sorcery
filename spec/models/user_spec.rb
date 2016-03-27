require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without an email' do
    user = User.create(
        password: 'password',
        password_confirmation: 'password')
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password when creating a new user' do
    user = User.create(email: 'jack.sparrow@test.com')
    expect(user).to_not be_valid
    expect(user.errors[:password]).to include("is too short (minimum is 3 characters)")
  end

  it 'is invalid without a password confirmation when we provide a password' do
    user = User.new(
        email: 'jack.sparrow@test.com',
        password: 'password')
    expect(user).to_not be_valid
    expect(user.errors[:password_confirmation]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryGirl.create(:jack_sparrow)
    user = User.new(
        email: 'jack.sparrow@test.com',
        password: 'password',
        password_confirmation: 'password')
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

  describe 'Update' do

    it "changes the password only and only if we provide a new password" do
      user = FactoryGirl.create(:jack_sparrow)
      user.email = "test@test.com"
      crypted_password = user.crypted_password
      user.save
      user.reload
      expect(user.email).to eq("test@test.com")
      expect(user.crypted_password).to eq(crypted_password)

      user.password = "new_password"
      user.password_confirmation = "new_password"
      user.save
      user.reload
      expect(user.crypted_password).to_not eq(crypted_password)
    end

    it "changes the password only and only if we provide a new password" do
      user = FactoryGirl.create(:jack_sparrow)
      user.email = "test@test.com"
      crypted_password = user.crypted_password
      user.save
      user.reload
      expect(user.email).to eq("test@test.com")
      expect(user.crypted_password).to eq(crypted_password)

      user.password = "new_password"
      user.password_confirmation = "new_password"
      user.save
      user.reload
      expect(user.crypted_password).to_not eq(crypted_password)
    end

    it 'is invalid without a password confirmation when we provide a password' do
      user = FactoryGirl.create(:jack_sparrow)
      user.activate!
      user.password = 'dcba4321'
      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end
  end
end
