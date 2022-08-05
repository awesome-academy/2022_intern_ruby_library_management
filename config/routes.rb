Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      get "/home", to: "home#index"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      get "/register", to: "sessions#register"
      delete "/logout", to: "sessions#destroy"
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
      resources :order, :carts
      get "/order", to: "order#index"
      resources :products, only: :show do
        collection do
          get "search", to: "search#index"
        end
      end
    end
    get "/login", to: "admin/sessions#new"
  end
end
