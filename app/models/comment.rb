class Comment < ApplicationRecord
  has_one_attached :image

  belongs_to :post
  belongs_to :user

  # 下記コメントにコメントを付ける機能
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  validates :body, length: { maximum: 50, message: 'は50文字以内で入力してください。' }
  validates :image, presence: true, if: -> { body.blank? }
  validates :body, presence: true, if: -> { image.blank? }

end
