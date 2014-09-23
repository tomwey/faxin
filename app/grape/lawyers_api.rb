# coding: utf-8
require 'entities'
require 'helpers'

module Faxin
  class LawyersAPI < Grape::API
    
    resources :lawyers do
      params do
        requires :name, type: String, desc: "姓名"
        requires :avatar
        requires :photo
      end
      
      post '/' do
        Lawyer.create!(real_name: params[:name], avatar: params[:avatar], lawyer_card_image: params[:photo])
      end
      
      params do
        
      end
      
    end
    
  end
end