Rails.application.routes.draw do
  get 'home/cities'
  resources :boletos
  get "cities", controller: "home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "boletos#index"
end
