# frozen_string_literal: true

5.times do |i|
  Post.create!(
    title: "Pet#{i}",
    image: open("#{Rails.root}/db/fixtures/pet_image#{i}.jpg"),
    content: "うちのPet#{i}が可愛いすぎる"
  )
end
