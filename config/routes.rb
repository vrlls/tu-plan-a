Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :categories, only: [:index, :create, :show] do
        resources :places, only: [:index], controller: "categories/places"
      end
      resources :places, only: [:index, :create, :show, :destroy, :update]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
