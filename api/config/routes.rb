Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope :api do
    namespace :v1 do
      resources :cooking_recipes, path: "/cooking-recipes", param: :slug

      post "sign-up" => "sign_up#create"

      post "auth" => "auth/sessions#create"
      delete "auth" => "auth/sessions#destroy"

      post "auth/password/request" => "auth/passwords#reset_request"
      get "auth/password/edit" => "auth/passwords#edit"
      put "auth/password" => "auth/passwords#update"

      post "auth/unlock/request" => "auth/unlocks#unlock_request"
      get "auth/unlock" => "auth/unlocks#unlock"

      post "auth/confirmation/request" => "auth/confirmations#confirmation_request"
      get "auth/confirmation" => "auth/confirmations#confirmation"

      get "me" => "me#index"
      patch "me" => "me#update"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
