FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'

    factory :valid_user do 
      email 'valid_user@example.com'
    end

    factory :invalid_user do 
      email  'invalid_user.com'
    end
  end
end