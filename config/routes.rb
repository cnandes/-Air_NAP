Rails.application.routes.draw do
  devise_for :users
  root to: "nap_spaces#home"

  resources :nap_spaces
  # get "/nap_space", to: "nap_spaces#home"
  # get "/nap_space/index", to: "nap_spaces#index"
  # get "/nap_space/index/show", to: "nap_spaces#show"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
