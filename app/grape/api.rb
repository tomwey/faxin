# coding: utf-8
require 'entities'
require 'helpers'
require 'search_api'
require 'users_api'
require 'purchase_api'
require 'law_type_api'
require 'laws_api'
require 'cases_api'

module Faxin
  class API < Grape::API
    prefix :api
    format :json
    
    helpers APIHelpers
    
    mount UsersAPI
    mount PurchaseAPI
    mount SearchAPI
    mount LawTypeAPI
    mount CasesAPI
    mount LawsAPI
    
  end

end