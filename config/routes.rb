Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, controllers: { sessions: "users/sessions" }
    as :user do
      get "/login", to: "users/sessions#new"
      post "/login", to: "users/sessions#create"
      delete "/logout", to: "users/sessions#destroy"
      get "/signup", to: "users/registration#new"
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
      resources :products, only: :show
      resources :order, :carts, :comments
      get "/order", to: "order#index"
      resources :products, only: :show do
        collection do
          get "search", to: "search#index"
        end
      end
    end
  end
end
