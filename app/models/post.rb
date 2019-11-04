# frozen_string_literal: true

# ペットの記事モデルクラス
class Post < ApplicationRecord
  mount_uploader :image, ImagesUploader
  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
