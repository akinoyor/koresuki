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
Admin.find_or_create_by!(email: admin_email) do |admin|
  admin.password = admin_password
end

User.find_or_create_by!(email: 'visitor@example.com') do |user|
      user.password = "PFvisitor"
      user.name = "Visitor"
end

gest = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.profile ="ゲストユーザーです"
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

inuhosi = User.find_or_create_by!(email: "inuhosi@koresuki.com") do |user|
  user.name = "犬ほし"
  user.password = "aaaaaa"
  user.profile = "犬飼いたい!猫も可愛い"
  user.user_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/icon_dog2.jpg"), filename:"icon_dog2.jpg")
end

post1 = Post.find_or_create_by!(body: "子猫可愛い！") do |post|
  post.user_id = nekotomo.id
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/child_cat.jpg"), filename:"child_cat.jpg")
end


post2 = Post.find_or_create_by!(body: "犬も猫も可愛いなぁ") do |post|
  post.user_id = inuhosi.id
end

post3 = Post.find_or_create_by!(body: "") do |post|
  post.user_id = inusuki.id
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/dog_flower.jpg"), filename:"dog_flower.jpg")
end

post4 = Post.find_or_create_by!(body: "箱入り猫！") do |post|
  post.user_id = nekosuki.id
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/cat.jpg"), filename:"cat.jpg")
  post.created_at = Time.now - 5.minutes
end

comment1 = Comment.find_or_create_by!(body: "子犬も可愛い！") do |comment|
  comment.user_id = inusuki.id
  comment.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/child_dog.jpg"), filename:"child_dog.jpg")
  comment.post_id = post1.id
end

Comment.find_or_create_by!(body: "どっちも可愛い！") do |comment|
  comment.user_id = inuhosi.id
  comment.post_id = post1.id
  comment.parent_comment_id = comment1.id
end

Comment.find_or_create_by!(body: "どちらもいいですよね！") do |comment|
  comment.user_id = nekosuki.id
  comment.post_id = post2.id
end

Follow.find_or_create_by(follower_id: inuhosi.id ,followed_id: nekosuki.id)
Follow.find_or_create_by(follower_id: inuhosi.id ,followed_id: inusuki.id)
Follow.find_or_create_by(follower_id: inuhosi.id ,followed_id: nekotomo.id)
Follow.find_or_create_by(follower_id: nekosuki.id ,followed_id: inuhosi.id)
Follow.find_or_create_by(follower_id: nekosuki.id ,followed_id: nekotomo.id)
Follow.find_or_create_by(follower_id: nekotomo.id ,followed_id: nekosuki.id)

Bookmark.find_or_create_by(user_id: inuhosi.id, post_id: post1.id )
Bookmark.find_or_create_by(user_id: inuhosi.id, post_id: post2.id )
Bookmark.find_or_create_by(user_id: inuhosi.id, post_id: post3.id )
Bookmark.find_or_create_by(user_id: inuhosi.id, post_id: post4.id )

Preset.find_or_create_by!(user_id: gest.id, number: "1") do |preset|
  preset.name = "犬猫兼用"
  preset.words = "犬 猫"
  preset.option = "oa"
end
puts "seedの実行が完了しました。"