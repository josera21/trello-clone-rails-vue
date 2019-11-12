Rails.application.routes.draw do
  resources :cards
  resources :lists do
    member do
      patch :move
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'lists#index'
end
