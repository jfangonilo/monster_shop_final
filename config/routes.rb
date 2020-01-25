Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "welcome#index"

  # namespace :merchant, as: :merchant_dash do

  #   resources :items, only: [:index, :edit, :update, :destroy] do
  #     patch "/toggle_active", to: "items#toggle_active"
  #   end

  #   resources :orders, only: [:show] do
  #     resources :item_orders, only: [] do
  #       patch "/fulfill", to: "orders#fulfill"
  #     end
  #   end

  #   resources :items, only: [:index, :new, :create]
  #   resources :coupons
  #   get "/", to: "dashboard#index"
  # end

  get "/merchant", to: "merchant/dashboard#index", as: :merchant_dash

  get "/merchant/coupons", to: "merchant/coupons#index"
  get "/merchant/coupons/new", to: "merchant/coupons#new"
  post "/merchant/coupons", to: "merchant/coupons#create"
  get "/merchant/coupons/:id", to: "merchant/coupons#show"
  patch "/merchant/coupons/:id", to: "merchant/coupons#update"
  get "/merchant/coupons/:id/edit", to: "merchant/coupons#edit"
  delete "/merchant/coupons/:id", to: "merchant/coupons#destroy"

  get "/merchant/items", to: "merchant/items#index"
  get "/merchant/items/new", to: "merchant/items#new"
  post "/merchant/items", to: "merchant/items#create"
  get "/merchant/items/:id", to: "merchant/items#show"
  patch "/merchant/items/:id", to: "merchant/items#update"
  get "/merchant/items/:id/edit", to: "merchant/items#edit"
  delete "/merchant/items/:id", to: "merchant/items#destroy"
  patch "/merchant/items/:id/toggle_active", to: "merchant/items#toggle_active"

  get "/merchant/orders/:id", to: "merchant/orders#show"
  patch "/merchant/orders/:order_id/item_orders/:item_order_id/fulfill", to: "merchant/orders#fulfill"

  # namespace :admin, as: :admin_dash do

  #   resources :users, only: [:index, :show, :edit, :update] do
  #     get "/edit_password", to: "users#edit_password"
  #     patch "/toggle_active", to: "users#toggle_active"
  #     get "/edit_role", to: "users#edit_role"
  #     patch "/role", to: "users#update_role"

  #     resources :orders, only: [:show] do
  #       patch "/cancel", to: "orders#cancel"
  #       patch "/ship", to: "orders#ship"
  #     end
  #   end

  #   resources :merchants, only: [:index, :show] do
  #     resources :items, only: [:index, :new, :create, :edit, :update]
  #     patch "/toggle_active", to: "merchants#toggle_active"
  #   end

  #   resources :items, only: [] do
  #     patch "/toggle_active", to: "items#toggle_active"
  # end

  #   resources :orders, only: [:update]
  #   get "/", to: "dashboard#index"
  # end

  get "/admin/users", to: "admin/users#index"
  get "/admin/users/:id", to: "admin/users#show"
  get "/admin/users/:id/edit", to: "admin/users#edit"
  patch "/admin/users/:id", to: "admin/users#update"
  get "/admin/users/:id/edit_password", to: "admin/users#edit_password"
  patch "/admin/users/:id/toggle_active", to: "admin/users#toggle_active"
  get "/admin/users/:id/edit_role", to: "admin/users#edit_role"
  patch "/admin/users/:id/role", to: "admin/users#update_role"

  get "/admin/users/:user_id/orders/:order_id", to: "admin/orders#show"
  patch "/admin/users/:user_id/orders/:order_id/cancel", to: "admin/orders#cancel"
  patch "/admin/users/:user_id/orders/:order_id/ship", to: "admin/orders#ship"

  get "/admin/merchants", to: "admin/merchants#index"
  get "/admin/merchants/:id", to: "admin/merchants#show"
  patch "/admin/merchants/:merchant_id/toggle_active", to: "admin/merchants#toggle_active"

  get "/admin/merchants/:merchant_id/items", to: "admin/items#index"
  get "/admin/merchants/:merchant_id/items/new", to: "admin/items#new"
  post "/admin/merchants/:merchant_id/items", to: "admin/items#create"
  get "/admin/merchants/:merchant_id/items/:item_id/edit", to: "admin/items#edit"
  patch "/admin/merchants/:merchant_id/items/:item_id", to: "admin/items#update"

  get "/admin", to: "admin/dashboard#index", as: :admin_dash
  patch "/admin/orders/:id", to: "admin/orders#update"
  patch  "/admin/items/:id/toggle_active", to: "admin/items#toggle_active"

  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end
  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id", to: "merchants#show"
  patch "/merchants/:id", to: "merchants#update"
  get "/merchants/:id/edit", to: "merchants#edit"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/merchants/:id/items", to: "items#index"
  get "/merchants/:id/items/new", to: "items#new"
  post "/merchants/:id/items", to: "items#create"

  # resources :items do
  #   resources :reviews, only: [:new, :create]
  # end
  get "/items", to: "items#index"
  get "/items/new", to: "items#new"
  post "/items", to: "items#create"
  get "/items/:id", to: "items#show"
  patch "/items/:id", to: "items#update"
  get "/items/:id/edit", to: "items#edit"
  delete "/items/:id", to: "items#destroy"

  get "items/:item_id/reviews/new", to: "reviews#new"
  post "items/:item_id/reviews", to: "reviews#create"

  # resources :reviews, only: [:edit, :update, :destroy]
  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

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

  post "/cart/coupon", to: "coupon#update"
  post "/cart/:item_id", to: "cart#add_item"
  patch "/cart/:item_id", to: "cart#add_subtract_cart"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"
end
