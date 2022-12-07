Rails.application.routes.draw do
  devise_for :users
  root to: "nap_spaces#home"

  resources :nap_spaces do
    resources :bookings, only: %i[new create]
  end
  resources :bookings, only: [:index, :show] do
    resources :reviews, only: [:create, :index, :show]
  end

  get '/bookings/:id/confirm', to: 'bookings#confirm', as: :booking_confirm
  get '/bookings/:id/decline', to: 'bookings#decline', as: :booking_decline
  get '/bookings/:id/cancel', to: 'bookings#cancel', as: :booking_cancel

  # get "/nap_space", to: "nap_spaces#home"
  # get "/nap_space/index", to: "nap_spaces#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
