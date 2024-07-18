Rails.application.routes.draw do
  root "home#index"

  post "/add_item", to: "home#add_item"
  get "/cart", to: "home#cart"

  resources :home, only: [:index]
end
