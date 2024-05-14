class Preset < ApplicationRecord
  exnum target: { all_user: 0, following_user: 1 },_prefix: true
  exnum option: { katu: 0, oa: 1 }, _prefix: true

  belongs_to :user
  has_many :preset_words, dependent: :destroy


end
