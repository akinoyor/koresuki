class Comment < ApplicationRecord
  has_one_attached :image

  belongs_to :post
  belongs_to :user

  # 下記コメントにコメントを付ける機能
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  validates :body, length: { maximum: 50 }
  validates :image, presence: true, if: -> { body.blank? }
  validates :body, presence: true, if: -> { image.blank? }

  def created_at_jp
    created_at.in_time_zone('Asia/Tokyo').strftime('%Y年%m月%d日 %H時%M分')
  end

end
