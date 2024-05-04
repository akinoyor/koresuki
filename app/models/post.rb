class Post < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :bookmarks,  dependent: :destroy
  has_many :comments,   dependent: :destroy
end
