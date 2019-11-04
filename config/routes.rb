Rails.application.routes.draw do
  #root to: 'home#index'
  root to: 'posts#index'
  resources :posts, only: [:index]
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:show]
    end
  end
end
