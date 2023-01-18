Rails.application.routes.draw do
  get 'shopper/order'
  post 'shopper/cart'
  get 'shopper/cart'
  get 'shopper/index'
  post 'shopper/index'
  get 'shopper/login'
  post 'shopper/login'
  get 'shopper/new'
  post 'shopper/new'
  get 'shopper/logout'
  get 'admin/login'
  post 'admin/login'
  get 'admin/logout'
  resources :products
  root :to => 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
