# coding: utf-8
require 'entities'
require 'helpers'

module Faxin
  class APIV2 < Grape::API
    prefix :api
    version "v2"
    format :json
    
    helpers APIHelpers
    
    ######################## 用户相关接口 ###################################
    use Rack::Session::Cookie, :secret => "1175ebb529d2cc7b6523755577dc298fba3a8587b01242751bf6c4d285b4178fc71616e9ea830a078a5f4cd3c5e33822fa008ae4bb4dc512028dc3a8da24c8f4" 
    
    use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = Faxin::UsersAPI
    end
    
    resources :user do
      # 获取用户个人信息
      get '/me' do
        user = authenticate!
        
        # present user, :with => APIEntities::UserDetail
        # 
        # render_success_with_body(body())
        
        render_success_with_data(user.to_json)
        
      end # end 获取用户个人信息
      
      # 修改用户基本信息
      params do
        optional :avatar
        optional :nickname, type: String, desc: "用户昵称"
      end
      post '/update_profile' do
        user = authenticate!
        
        if params[:avatar]
          user.avatar = params[:avatar]
        end
        
        if params[:nickname]
          user.nickname = params[:nickname]
        end
        
        if user.save
          render_success_with_data(user.to_json)
        else
          puts user.errors.full_messages
          render_error_json_no_data(1030, '更新用户资料失败')
        end
        
      end # end 修改用户基本信息
      
      # 修改律师信息
      post '/update_lawyer_info' do
        user = authenticate!
        
        profile = user.profile
        if profile.blank?
          profile = Lawyer.new
          profile.user = user
        end
        
        if params[:real_name]
          profile.real_name = params[:real_name]
        end
        
        if params[:lawyer_card]
          profile.lawyer_card = params[:lawyer_card]
        end
        
        if params[:city]
          profile.city = params[:city]
        end
        
        if params[:law_firm]
          profile.law_firm = params[:law_firm]
        end
        
        if params[:mobile]
          profile.mobile = params[:mobile]
        end
        
        if params[:intro]
          profile.intro = params[:intro]
        end
        
        if params[:photo]
          profile.lawyer_card_image = params[:photo]
        end
        
        if profile.save
          present profile, :with => APIEntities::LawyerDetail
        
          render_success_with_body(body())
        else
          render_error_json_no_data(1031, '保存律师资料失败')
        end
        
      end
      
    end
    
    ######################## 注册登录相关API ################################
    resource "account" do
      # 注册
      params do
        requires :email, type: String, desc: "邮箱"
        requires :password, type: String, desc: "密码"
        optional :code, type: String, desc: "邀请码"
      end
      post '/' do
        
        user = User.find_by_email(params[:email])
        if user.present?
          return render_error_json_no_data(1001, '用户已经存在')
        end
        
        if params[:password].length < 6
          return render_error_json_no_data(1002, '密码长度不应该小于6位')
        end
        
        @user = User.new(email:params[:email], password:params[:password], password_confirmation: params[:password])
        if @user.save
          warden.set_user(@user)
          @user.registered_os = os_name
          @user.ensure_private_token!
          
          # 如果传了邀请码，那么尝试激活邀请
          if params[:code]
            invite = Invite.find_by_invitee_email_and_code(params[:email], params[:code])
            if invite and not invite.is_actived
              Invite.transaction do
                if invite.user
                  invite.update_attribute("is_actived", true)
          
                   # 送给邀请者1个月vip数据使用
                   # invite.user.update_vip_status(2)
                   # # 送自己一个月
                   # @user.update_vip_status(2)
               end # end if
              end # end transaction
            end # end if
          else
            # @user.update_vip_status(2)
          end # end if
          
          # 发欢迎邮件
          UserMailer.welcome(@user).deliver
          
          render_success_with_data(@user.to_json)
        else
          render_error_json_no_data(1003, '注册用户失败')
        end        
      end # end 注册
      
      # 登录
      params do
        requires :email, type: String, desc: "邮箱"
        requires :password, type: String, desc: "密码"
      end
      post '/login' do
        user = User.find_by_email(params[:email])
        unless user
          return render_error_json_no_data(1004, '登录的邮箱不存在')
        end
        
        user = warden.authenticate(:password)
        if user
          # 记录登录信息
          user.last_logined_os = os_name
          user.last_logined_at = Time.zone.now
          # 更新private token
          user.update_private_token
          render_success_with_data(user.to_json)
        else
          render_error_json_no_data(1005, '登录密码不正确')
        end
        
      end # end 登录
      
      # 退出登录
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        
        warden.logout
        render_success
      end # end 退出登录
      
      # 忘记密码
      params do
        requires :email, type: String, desc: "邮箱"
      end
      post '/password/forget' do
        user = User.find_by_email(params[:email])
        unless user
          return render_error_json_no_data(1004, '账号不存在')
        end
        user.send_password_reset
        render_success
      end # end 忘记密码
      
      # 重置密码
      params do
        requires :code, type: String, desc: "验证码"
        requires :password, type: String, desc: "密码"
        requires :password_confirmation, type: String, desc: "确认密码"
      end
      post '/password/reset' do
        @user = User.find_by_password_reset_token!(params[:code])
        
        unless @user
          return render_error_json_no_data(1007, '重置验证码不正确')
        end
        
        if params[:password].length < 6 or params[:password_confirmation].length < 6
          return render_error_json_no_data(1002, '密码长度不应该小于6位')
        end
        
        if @user.password_reset_sent_at < 2.hours.ago
          render_error_json_no_data(1008, '验证码已过期')
        elsif params[:password] != params[:password_confirmation]
          render_error_json_no_data(1009, '两次输入密码不一致')
        elsif @user.update_attribute(:password, params[:password])
          render_success
        else
          render_error_json_no_data(1010, '未知原因重置密码失败')
        end
      end # end 重置密码
      
      # 修改密码
      params do
        requires :token, type: String, desc: "认证token"
        requires :old_password, type: String, desc: "旧密码"
        requires :password, type: String, desc: "新密码"
        requires :password_confirmation, type: String, desc: "确认新密码"
      end
      post '/password/update' do
        user = authenticate!
        params.delete(:token)
        
        # 如果全部留白，那么直接返回成功，表示不需要修改密码
        if params[:old_password].blank? and params[:password].blank? and params[:password_confirmation]
          return render_success
        end
        
        if params[:password].length < 6 or params[:password_confirmation].length < 6
          return render_error_json_no_data(1002, '密码长度不应该小于6位')
        end
        
        if params[:password] != params[:password_confirmation]
          return render_error_json_no_data(1009, '两次输入密码不一致')
        end
        
        if not user.try(:authenticate, params[:old_password])
          return render_error_json_no_data(1011, '旧密码不正确')
        end
        
        if user.update_attribute(:password, params[:password])
          render_success
        else
          render_error_json_no_data(1012, '未知原因的修改密码失败')
        end
        
      end # end 修改密码
      
    end # end account
    
    
  end # end class
  
end # end module