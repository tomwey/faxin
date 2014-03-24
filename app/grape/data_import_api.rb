# coding: utf-8
require 'entities'
require 'helpers'

module Faxin
  class DataImportAPI < Grape::API
    resources :laws do
      post '/input' do
        puts '--> ' + params[:content]
        Law.create!(:title => params[:title], 
                    :pub_dept => params[:pub_dept], 
                    :pub_date => params[:pub_date], 
                    :impl_date => params[:impl_date],
                    :doc_id => params[:summary],
                    :law_type_id => params[:law_type_id],
                    :location_id => params[:location_id],
                    :content => params[:content] )
      end
    end
  end
end