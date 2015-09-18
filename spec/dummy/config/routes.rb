Rails.application.routes.draw do
  mount Shopper::Engine => '/cart', as: 'shopper'

  root 'products#index'

  resources :products
end
