# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seedの実行開始。"
require 'dotenv'
Dotenv.load
admin_email = ENV['ADMIN_EMAIL']
admin_password = ENV['ADMIN_PASSWORD']
admin = Admin.find_or_create_by!(email: admin_email) do |admin|
  admin.password = admin_password
  end

nekosuki = User.find_or_create_by!(email: "nekosuki@koresuki.com") do |user|
  user.name = "猫すきー"
  user.password = "aaaaaa"
  user.profile = "猫大好き！"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/icon_cat1.jpg"), filename:"icon_cat1.jpg")
end

nekotomo = User.find_or_create_by!(email: "nekotomo@koresuki.com") do |user|
  user.name = "ネコとも"
  user.password = "aaaaaa"
  user.profile = "猫は友達！どこでもいっしょ！"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/icon_cat2.jpg"), filename:"icon_cat2.jpg")
end

inusuki = User.find_or_create_by!(email: "inusuki@koresuki.com") do |user|
  user.name = "犬すきー"
  user.password = "aaaaaa"
  user.profile = "犬好き！"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/icon_dog1.jpg"), filename:"icon_dog1.jpg")
end

inukai = User.find_or_create_by!(email: "inukai@koresuki.com") do |user|
  user.name = "犬ほし"
  user.password = "aaaaaa"
  user.profile = "犬飼いたい!猫も可愛い"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/icon_dog2.jpg"), filename:"icon_dog2.jpg")
end

puts "seedの実行が完了しました。"