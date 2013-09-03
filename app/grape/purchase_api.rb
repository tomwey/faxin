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
          return render_error_json(400, '你已经验证过了购买')
        end
        
          receipt = params[:receipt]
        
          bid = params[:bid] || 'com.kekestudio.LawLibrary'
          count = params[:month_count].to_i
              
          if count <= 0
            return render_error_json(422, '不正确的月数')
          end
          
          user.verify(User::VERIFY_PRODUCTION, receipt, bid, count)
        
        # if result
        #   puts 'ok ------ 0k'
        # end
        
        #       
        # user.update_vip_status(count)
        # Purchase.create(:content => count, :user_id => user.id)
      end
    end
    
  end
end