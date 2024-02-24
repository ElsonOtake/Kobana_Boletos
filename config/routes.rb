Rails.application.routes.draw do
  resources :boletos
  get "cities", controller: "home"
  root "boletos#index"
end
