Rails.application.routes.draw do
  devise_for :users
  root to: "nap_spaces#home"

  resources :nap_spaces do
    resources :bookings, only: %i[new create]
  end
  resources :bookings, only: %i[index] do
    resources :reviews, only: %i[index show new create]
  end

  get '/bookings/:id/confirm', to: 'bookings#confirm', as: :booking_confirm
  get '/bookings/:id/decline', to: 'bookings#decline', as: :booking_decline
  get '/bookings/:id/cancel', to: 'bookings#cancel', as: :booking_cancel
  get '/my_nap_spaces/', to: 'nap_spaces#index_by_user', as: :user_nap_spaces
  # get "/nap_space", to: "nap_spaces#home"
  # get "/nap_space/index", to: "nap_spaces#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
