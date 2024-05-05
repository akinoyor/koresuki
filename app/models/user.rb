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
    user_image.variant(resize_to_limit: [width,height]).processed
  end

  has_many :presets, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  validates :name, presence: true ,length: {in: 2..20 }
  validates :password, presence: true, on: :create
end
