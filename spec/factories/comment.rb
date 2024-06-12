FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { Faker::Lorem.characters(number: 30) }

    trait :with_parent do
      association :parent_comment, factory: :comment
    end
  end
end
