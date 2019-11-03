Rails.application.routes.draw do
  devise_for :users

  # root to: 'pages#home'
  root to:  'bundles#index'
  resources :bundles
  resources :users, only: [:show]
  resources :subscriptions, only: [:new, :create]
  resources :payments, only: [:create]
end
