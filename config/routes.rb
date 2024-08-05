Rails.application.routes.draw do
  root "home#index"

  post "/add_item", to: "home#add_item"
  get "/cart", to: "home#cart"

  resources :home, only: [:index]
  resources :orders do
    collection do
      post :notify 
    end
  end
end
