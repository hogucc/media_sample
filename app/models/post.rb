class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
