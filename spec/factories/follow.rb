FactoryBot.define do
  factory :follow do
    association :follower
    association :followed
  end
end