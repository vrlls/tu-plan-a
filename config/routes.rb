Rails.application.routes.draw do
  namespace :api do
    post 'user_token' => 'user_token#create'
    scope '/auth' do
      post '/signin', to: 'user_token#create'
      post '/signup', to: 'users#create'
    end
    namespace :v1 do
      resources :categories, only: [:index, :create, :show] do
        resources :places, only: [:index], controller: "categories/places"
      end
      resources :places, only: [:index, :create, :show, :destroy, :update]
      resources :users, except: [:create]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
