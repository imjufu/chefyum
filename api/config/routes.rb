Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      post "auth" => "auth/sessions#create"
      delete "auth" => "auth/sessions#destroy"

      post "auth/password/reset-request" => "auth/passwords#reset"
      get "auth/password/edit" => "auth/passwords#edit"
      put "auth/password" => "auth/passwords#update"

      post "auth/unlock/request" => "auth/unlocks#unlock_request"
      get "auth/unlock" => "auth/unlocks#unlock"

      get "me" => "me#index"
      patch "me" => "me#update"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
