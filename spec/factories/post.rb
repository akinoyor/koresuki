FactoryBot.define do
  factory :post do
    association :user
    body { Faker::Lorem.characters(number: 30) }
  end
end
