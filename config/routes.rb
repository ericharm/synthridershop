Rails.application.routes.draw do
  devise_for :users

  root to:  'bundles#index'
  # resources :bundles
  resources :songs, controller: 'bundles'
  resources :subscriptions, only: [:index, :new]
  resources :payments, only: [:create]
  resources :account, only: [:index]
  resources :search, only: [:create]

  # resources :approvals, only: [:create]
  post 'songs/:id/approve', to: 'bundles#approve', as: :approve
  get 'users/:username', to: 'users#show', as: :user

  get '/about' => 'pages#show', page: 'about', as: :about
  get '/terms' => 'pages#show', page: 'terms', as: :terms
  get '/privacy' => 'pages#show', page: 'privacy', as: :privacy
  get '/legal' => 'pages#show', page: 'legal', as: :legal
  get '/contribute' => 'pages#show', page: 'contribute', as: :contribute
  get '/contact' => 'pages#show', page: 'contact', as: :contact
  get '/help' => 'pages#show', page: 'help', as: :help
end
