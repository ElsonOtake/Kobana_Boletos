Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt/ do
    resources :boletos, except: :destroy do
      member do
        get "cancel"
        patch "cancel_by_id"
      end
    end

  end
  get "cities", controller: "home"
  get '/:locale' => 'boletos#index'
  root "boletos#index"
end
