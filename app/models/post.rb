class Post < ApplicationRecord
  has_one_attached :post_image
  belongs_to :user
  has_many :bookmarks,  dependent: :destroy
  has_many :comments,   dependent: :destroy

validates :post_image, presence: true, if: -> { body.blank? }
validates :body, presence: true, if: -> { post_image.blank? }

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end
end
