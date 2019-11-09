json.set! :post do
  json.array! @posts do |post|
    json.extract! post, :id, :title
  end
end
