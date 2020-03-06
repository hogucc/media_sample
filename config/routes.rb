Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show, :create, :destroy]
    end
  end
end
