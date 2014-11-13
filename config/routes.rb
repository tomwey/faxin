Faxin::Application.routes.draw do
  
  # devise_for :users, :path => "account", :controllers => {
  #   :sessions => :sessions
  # }

  require 'api'
  require 'api_v2'
  
  get "login", to: "sessions#new", as: "login"
  get "logout", to: 'sessions#destroy', as: "logout"
  
  resources :users, :except => [:destroy] do
    collection do 
      get :search
    end
  end
  resources :sessions

  resources :law_types
  resources :laws
  
  resources :site_configs
  
  resources :anyous
  resources :cases
  resources :reports
  
  resources :purchases, only: [:index]
  resources :binds, only: [:index, :new, :create, :edit, :update]
  resources :invites, only: [:index, :new, :create, :active] do
    member do
      put :active
    end
  end
  
  resources :active_codes, only: [:index,:new,:create, :buy, :unbuy, :destroy] do
    member do
      put :buy
      put :unbuy
    end
  end
  
  match '/search' => 'search#index', :as => :search, :via => :get
  match '/search/cases' => 'search#cases', :as => :search_cases, :via => :get
  match '/search/active_codes' => 'search#active_codes', :as => :search_active_codes, :via => :get
  
  root to: "home#index"
  
  mount Faxin::API => '/'
  mount Faxin::APIV2 => '/'
  
end
