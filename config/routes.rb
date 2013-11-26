Faxin::Application.routes.draw do
  
  # devise_for :users, :path => "account", :controllers => {
  #   :sessions => :sessions
  # }

  require 'api'
  
  get "login", to: "sessions#new", as: "login"
  get "logout", to: 'sessions#destroy', as: "logout"
  
  resources :users
  resources :sessions

  resources :law_types
  resources :laws
  
  resources :anyous
  resources :cases
  
  resources :active_codes, only: [:index,:new,:create, :buy, :unbuy, :destroy] do
    member do
      put :buy
      put :unbuy
    end
  end
  
  match '/search' => 'search#index', :as => :search, :via => :get
  match '/search/cases' => 'search#cases', :as => :search_cases, :via => :get
  
  root to: "home#index"
  
  mount Faxin::API => '/'
  
end
