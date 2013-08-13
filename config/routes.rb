Faxin::Application.routes.draw do
  require 'api'
  
  root to:"home#index"
  
  mount Faxin::API => '/'
end
