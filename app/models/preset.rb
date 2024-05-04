class Preset < ApplicationRecord
  enum target: { all_user: 0, following_user: 1 }
  enum optoon: { and: 0, or: 1 }
end
