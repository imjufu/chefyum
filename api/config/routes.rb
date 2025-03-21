Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
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

  get "up" => "rails/health#show", as: :rails_health_check
end
