require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.role == 'admin' } do
    resources :parking_slots
    # resources :users
    resources :vehicle_models
    resources :payment_types
    mount Sidekiq::Web => '/sidekiq'
  end

  authenticate :user do 
    # Defines route
    root "home#index"
    resources :vehicles
    resources :vehicle_models, only: [:index]
    resources :bookings
    resources :parking_slots, only: [:index, :update]
    resources :payments
    resources :profiles
    get 'settings', to: 'settings#profile'
    get 'settings/security', to: 'settings#security'
    get 'chart_data', to: 'home#chart_data'
    get 'parking_data', to: 'home#parking_data'
    
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  devise_for :users

  
end
