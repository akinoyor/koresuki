FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password'}
    password_confirmation { 'password' }
    profile{ Faker::Lorem.characters(number:10)}
    
    trait :guest do
      name { 'ゲストユーザー' }
      email{ 'guest@example.com' } 
    end
  end
end