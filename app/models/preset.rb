class Preset < ApplicationRecord
  exnum target: { all_user: 0, following_user: 1 },_prefix: true
  exnum option: { katu: 0, oa: 1 }, _prefix: true

  belongs_to :user

validates :name, presence: true ,length: {in: 1..10 }
validates :words, length: { maximum: 20 }
end
