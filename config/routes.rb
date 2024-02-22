Rails.application.routes.draw do
  get 'boletos/index'
  get 'boletos/show'
  get 'boletos/create'
  get 'boletos/cancel'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "boletos#index"
end
