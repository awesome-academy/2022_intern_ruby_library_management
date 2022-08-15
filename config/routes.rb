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
      resources :authors, :publishers
    end
    scope module: "website" do
      root "home#index"
      get "/order", to: "order#index"
    end
  end
end
