class Preset < ApplicationRecord
  enum target: { all_user: 0, following_user: 1 }
  enum option: { katu: 0, oa: 1 }

  belongs_to :user
  has_many :preset_words, dependent: :destroy

end
