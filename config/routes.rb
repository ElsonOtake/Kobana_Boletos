Rails.application.routes.draw do
  namespace :boletos do
    get 'show'
    get 'create'
    get 'cancel'
    get 'cities'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "boletos#index"
end
