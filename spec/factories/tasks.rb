FactoryGirl.define do
  factory :task do
    name { Faker::Lorem.sentence[1..40] }
    description { Faker::Lorem.paragraph(5)[1..500] }
    user nil
    state "new"
  end
end
