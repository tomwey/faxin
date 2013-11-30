# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class PurchaseAPI < Grape::API
        
    # 购买确认
    resource "buy" do
      params do
        optional :email, type: String, desc: "email" # required change to optional
        requires :receipt, type: String, desc: "购买凭证"
        requires :month_count, type: Integer, desc: "购买时长"
        optional :bid, type: String, desc: "bundle id"
        optional :udid, type: String, desc: "udid"
      end
      post '/verify' do
        # user = authenticate!
        
        purchase = Purchase.find_by_receipt(params[:receipt])
        
        if purchase.present?
          return render_error_json_no_data(3001, '你已经验证过了购买')
        end
        
        # 开始验证购买
        count = params[:month_count].to_i
        if count <= 0
          return render_error_json_no_data(3002, '购买的月数至少为1')
        end # endif count
        
        receipt = params[:receipt]
        bid = params[:bid] || 'com.kekestudio.LawLibrary'
        
        # 获取一个用户
        user = User.find_by_email(params[:email])
        if user.blank?
          user = User.find_by_udid(params[:udid])
          if user.blank?
            user = User.create!(udid: params[:udid], email: "#{Time.zone.now.to_i}@keke.cn", password: "123456")
          end
        end
        
        if user
          user.verify(User::VERIFY_PRODUCTION, receipt, bid, count)
        else
          render_error_json_no_data(3006, '验证购买失败，没有可以绑定的用户')
        end
        
      end # end post '/verify'
    end # end resources
    
  end
end