json.set! :posts do
  json.array! @posts do |post|
    json.extract! post, :id, :title, :image, :content
  end
end
