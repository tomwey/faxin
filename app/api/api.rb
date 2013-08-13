# coding: utf-8
require "entities"
require "helpers"
module Faxin
  class API < Grape::API
    format :json
    prefix 'api'
    
    get '/test' do
      { test: "很不错" }
    end
    # helpers APIHelpers
    # 
    # resource :cases do
    # end
  end
  
end