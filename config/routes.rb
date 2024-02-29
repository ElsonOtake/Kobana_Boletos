Rails.application.routes.draw do
  resources :boletos, except: :destroy
  get "cities", controller: "home"
  root "boletos#index"
end
