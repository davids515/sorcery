# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :jack_sparrow, class: User do
    email 'jack.sparrow@test.com'
    password 'password'
    password_confirmation 'password'
  end
end
