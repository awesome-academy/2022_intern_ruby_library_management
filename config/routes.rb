require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { sessions: "users/sessions", omniauth_callbacks: 'users/omniauth_callbacks'}
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, skip: :omniauth_callbacks
    as :user do
      get "/login", to: "users/sessions#new"
      post "/login", to: "users/sessions#create"
      delete "/logout", to: "users/sessions#destroy"
      get "/signup", to: "users/registrations#new"

      get 'auth/:provider/callback', to: 'sessions#create'
      get 'auth/failure', to: redirect('/')
    end
    namespace :admin do
      get "/home", to: "home#index"
      put "/user/activate:id", to: "users#update", :as => :user_activate
      resources :category
      resources :users
      resources :books
      resources :authors, :orders, :order_details, :publishers
    end
    scope module: "website" do
      root "home#index"
      get "/category_books/:id", to: "products#index", :as => :category
      delete "/reset_cart", to: "order#delete_all_cart"
      resources :order, :carts, :comments, :users
      get "/order", to: "order#index"
      resources :products do
        collection do
          get "search", to: "search#index"
          post "search", to: "search#show"
        end
      end
    end
    mount Sidekiq::Web => "/sidekiq"
  end
end
