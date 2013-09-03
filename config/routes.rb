Faxin::Application.routes.draw do
  
  # devise_for :users, :path => "account", :controllers => {
  #   :sessions => :sessions
  # }

  require 'api'

  resources :law_types
  resources :laws
  
  resources :anyous
  resources :cases
  
  root to:"home#index"
  
  mount Faxin::API => '/'
  
end
