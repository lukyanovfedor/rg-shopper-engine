Shopper::Engine.routes.draw do
  scope 'order' do
    post '/:class/:id', to: 'order#add_product', as: 'order_add_product'
    delete '/:class/:id', to: 'order#remove_product', as: 'order_remove_product'
  end

  resources :checkout, only: %i(show update)

  resource :cart, controller: :cart, path: '/', only: %i(show) do
    get 'complete'
  end

  root 'cart#show'
end
