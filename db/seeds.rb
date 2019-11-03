# frozen_string_literal: true

5.times do |i|
  Post.create!(
    title: "Pet#{i}",
    image: open("#{Rails.root}/db/fixtures/dog_image1.jpg"),
    content: "うちのPet#{i}が可愛いすぎる"
  )
end
