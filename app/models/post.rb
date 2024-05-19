class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :bookmarks,  dependent: :destroy
  has_many :comments,   dependent: :destroy
validates :body, length: { maximum: 50 }
validates :image, presence: true, if: -> { body.blank? }
validates :body, presence: true, if: -> { image.blank? }

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def self.search(keyword)
    where('body LIKE ?', "%#{keyword}%")
  end

  def child_comments
    comments.where(parent_comment_id: 0)
  end

end
