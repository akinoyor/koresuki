FactoryBot.define do
  factory :preset do
    association :user
    name { Faker::Lorem.characters(number: 5) }
    words { Faker::Lorem.characters(number: 2) }
    number { 1 }
  end
end
