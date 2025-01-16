Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      post "auth" => "auth/sessions#create"
      post "auth/password/reset-request" => "auth/passwords#reset"
      get "auth/password/edit" => "auth/passwords#edit"
      put "auth/password" => "auth/passwords#update"
      delete "auth" => "auth/sessions#destroy"

      get "me" => "me#index"
      patch "me" => "me#update"
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
