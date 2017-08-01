FactoryGirl.define do
  factory :task do
    name { Faker::Lorem.sentence[0..40] }
    description { Faker::Lorem.paragraph(5)[0..500] }
    user nil
    state "new"
  end
end
