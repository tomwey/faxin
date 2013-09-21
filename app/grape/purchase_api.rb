# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class PurchaseAPI < Grape::API
    # 购买确认
    resource "buy" do
      params do
        requires :token, type: String, desc: "认证token"
        requires :receipt, type: String, desc: "购买凭证"
        requires :month_count, type: Integer, desc: "购买时长"
        optional :bid, type: String, desc: "bundle id"
      end
      post '/verify' do
        user = authenticate!
        
        purchase = Purchase.find_by_receipt(params[:receipt])
        
        if purchase.present?
          return render_error_json_no_data(3001, '你已经验证过了购买')
        end
        
        receipt = params[:receipt]
        
        bid = params[:bid] || 'com.kekestudio.LawLibrary'
        count = params[:month_count].to_i
              
        if count <= 0
          return render_error_json_no_data(3002, '购买的月数至少为1')
        end
          
        if user
          user.verify(User::VERIFY_PRODUCTION, receipt, bid, count)
        end
        
      end
    end
    
  end
end