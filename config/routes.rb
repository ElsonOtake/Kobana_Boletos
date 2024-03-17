Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt/ do
    resources :boletos, except: :destroy
  end
  get "cities", controller: "home"
  get '/:locale' => 'boletos#index'
  root "boletos#index"
end
