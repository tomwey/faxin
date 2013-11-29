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
    
      # 购买确认2
      params do
        requires :udid, type: String, desc: "唯一标示"
        requires :receipt, type: String, desc: "购买凭证"
        requires :month_count, type: Integer, desc: "购买时长"
        optional :bid, type: String, desc: "bundle id"
      end
      post '/verify2' do
        
        receipt = params[:receipt]
        
        purchase = Purchase.find_by_receipt(receipt)
        if purchase.present?
          return render_error_json_no_data(3001, '你已经验证过了购买')
        end
        
        bid = params[:bid] || 'com.kekestudio.LawLibrary'
        count = params[:month_count].to_i
              
        if count <= 0
          return render_error_json_no_data(3002, '购买的月数至少为1')
        end
        
        udid = params[:udid]
        if udid.blank?
          return render_error_json_no_data(3006, 'udid为空')
        end
        
        device_info = DeviceInfo.find_or_create_by_udid(udid)
        if device_info
          VerifyReceipt.verify(VerifyReceipt::VERIFY_PRODUCTION_URL, receipt, count, bid, device_info)
        end
        
        
        # user = User.find_by_token(params[:token])
        # if user
        #   user.verify(User::VERIFY_PRODUCTION, receipt, bid, count)
        # end
      end
      
    end
    
  end
end