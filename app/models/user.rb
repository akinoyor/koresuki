class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :user_image
  def get_user_image(width, height)
    unless user_image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      user_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    user_image.variant(resize_to_fill: [width,height]).processed
  end

  has_many :presets, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

   # フォローしている関連付け
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy

  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy

  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed

  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

  validates :name, presence: true ,length: {in: 2..20 }
  validates :password, presence: true, on: :create
  validates :profile, length: { maximum: 50 }

  def self.search(keyword)
    where('name LIKE ?', "%#{keyword}%")
  end

end
