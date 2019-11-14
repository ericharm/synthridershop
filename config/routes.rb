Rails.application.routes.draw do
  devise_for :users

  # root to: 'pages#home'
  root to:  'bundles#index'
  resources :bundles
  # resources :users, only: [:show]
  resources :subscriptions, only: [:index, :new]
  resources :payments, only: [:create]

  get 'users/:username', to: 'users#show', as: :user
  get 'account', to: 'users#account', as: :account
end
