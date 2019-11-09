Rails.application.routes.draw do
  #root to: 'home#index'
  root to: 'posts#index'

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index]
    end
  end
end
