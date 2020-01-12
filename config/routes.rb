Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  namespace :merchant, as: :merchant_dash do

    resources :items, only: [:index, :edit, :update, :destroy] do
      patch "/toggle_active", to: "items#toggle_active"
    end

    resources :orders, only: [:show] do
      resources :item_orders, only: [] do
        patch "/fulfill", to: "orders#fulfill"
      end
    end

    resources :items, only: [:index, :new, :create]
    resources :coupons
    get "/", to: "dashboard#index"
  end

  namespace :admin, as: :admin_dash do

    resources :users, only: [:index, :show, :edit, :update] do
      get "/edit_password", to: "users#edit_password"
      patch "/toggle_active", to: "users#toggle_active"
      get "/edit_role", to: "users#edit_role"
      patch "/role", to: "users#update_role"

      resources :orders, only: [:show] do
        patch "/cancel", to: "orders#cancel"
        patch "/ship", to: "orders#ship"
      end
    end

    resources :merchants, only: [:index, :show] do
      resources :items, only: [:index, :new, :create, :edit, :update]
      patch "/toggle_active", to: "merchants#toggle_active"
    end

    resources :items, only: [] do
      patch "/toggle_active", to: "items#toggle_active"
    end

    resources :orders, only: [:update]
    get "/", to: "dashboard#index"
  end

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/edit_password", to: "users#edit_password"

  get "/profile/orders", to: "user/orders#index"
  get "/profile/orders/new", to: "user/orders#new"
  get "/profile/orders/:id", to: "user/orders#show"
  post "/orders", to: "user/orders#create"
  patch "/profile/orders/:id/cancel", to: "user/orders#cancel"

  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#add_subtract_cart"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
