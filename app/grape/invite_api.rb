# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class InviteAPI < Grape::API
    resource :invite do
      # 发出邀请
      params do
        requires :email, type: String, desc: "被邀请者邮箱"
        requires :token, type: String, desc: '认证token'
      end
      post '/send' do
        # 首先需要登录
        user = authenticate!
        
        # 检查用户是否已经存在
        u = User.find_by_email(params[:email])
        if u.present?
          return render_error_json_no_data(5001, '该用户已经存在')
        end
        
        # 检查是否邀请过
        invite = Invite.find_by_invitee_email(params[:email])
        if invite.present?
          return render_error_json_no_data(5002, '该用户已经被邀请过')
        end
        
        code = SecureRandom.base64(5).tr('+/=', '0aZ').strip.delete("\n")
        Invite.create!(:code => code, :invitee_email => params[:email], :user_id => user.id)
        render_success
        
      end
      
      # 激活邀请
      params do
        requires :code, type: String, desc: "邀请码"
        requires :token, type: String, desc: '认证token'
      end
      post '/active' do
        # 首先需要登录
        user = authenticate!
        
        invite = Invite.find_by_code(params[:code])
        if invite.blank?
          return render_error_json_no_data(5003, '该邀请码无效') 
        end
        
        if invite.is_actived
          return render_error_json_no_data(5004, '该邀请码已经被激活过') 
        end
        
        if invite.user == user
          return render_error_json_no_data(5005, '非法邀请码激活操作') 
        end
        
        # 激活邀请，并送给邀请人1个月vip数据使用
        Invite.transaction do
          invite.update_attribute("is_actived", true)
          
          # 送给用户1个月vip数据使用
          invite.user.update_vip_status(1)
        end
        
        render_success
      end
      
    end # end resource
    
  end # end class
end