FactoryGirl.define do
  factory :user do
    email { FactoryGirl.generate :email }
    password 'password'
    password_confirmation 'password'

    factory :admin do 
      admin true
    end

    factory :valid_user do 
      email 'valid_user@example.com'
    end

    factory :invalid_user do 
      email  'invalid_user.com'
    end

    trait :with_task do 
      after :create do |user|
        create(:task, user: user) 
      end
    end
  end
end