class Bookmark < ApplicationRecord
  blongs_to :user
  blongs_to :post
end
