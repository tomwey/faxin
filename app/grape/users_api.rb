# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class UsersAPI < Grape::API
    
    use Rack::Session::Cookie, :secret => "1175ebb529d2cc7b6523755577dc298fba3a8587b01242751bf6c4d285b4178fc71616e9ea830a078a5f4cd3c5e33822fa008ae4bb4dc512028dc3a8da24c8f4" 
    
    use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = Faxin::UsersAPI
    end
    
    # 获取VIP信息
    resource "user" do
      params do
        requires :token, type: String, desc: "认证Token"
      end
      get '/profile' do
        user = authenticate!
        render_success_with_data(user)
      end
      
      # 用户绑定
      params do
        requires :email, type: String, desc: "邮箱"
        requires :udid, type: String, desc: "设备UDID"
      end
      post '/bind' do
        # 任何一个为空值都没有意义
        if params[:udid].blank? or params[:email].blank?
          return render_error_json_no_data(2003, '参数值为空')
        end
        
        # 需要绑定的用户
        u1 = User.find_by_email(params[:email])
        if u1.blank?
          return render_error_json_no_data(1013, '要绑定的Email用户不存在')
        end
        
        # 被使用绑定的用户
        user = User.find_by_udid(params[:udid])
        if not user.try(:is_vip)
          return render_error_json_no_data(1014, '用来绑定的udid用户还不是vip用户')
        end
        
        User.transaction do
          #u1.udid = user.udid
          u1.vip_expired_at = user.vip_expired_at
          u1.save!
          user.vip_expired_at = nil
          user.save!
          
          Bind.create!(:email => params[:email], :udid => params[:udid])
        end
        
        render_success
        
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
          
                   # 送给用户1个月vip数据使用
                   invite.user.update_vip_status(1)
               end # end if
              end # end transaction
            end # end if
          end # end if
          
          render_success_with_data(@user)
        else
          render_error_json_no_data(1003, '注册用户失败')
        end        
      end
      
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
          render_success_with_data(user)
        else
          render_error_json_no_data(1005, '登录密码不正确')
        end
        
      end
      
      # 退出登录
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        
        warden.logout
        render_success
      end
      
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
      end
      
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
      end
      
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
        
      end
      
    end
    
    ######################## 收藏相关API ################################
    resource "user" do
      # 获取所有的收藏
      params do
        requires :token, type: String, desc: "认证token"
      end
      get '/favorites' do
        user = authenticate!
        
        favorite = Favorite.find_by_user_id(user.id)
        
        unless favorite
          return render_404_json
        end
        
        content = favorite.content
        
        unless content
          return render_404_json
        end
        
        # 1,1:2,3:2,1:2,3
        ids = content.split(':')
        result = []
        ids.each do |s_id|
          tid, id = s_id.split(',')
          if tid.to_i == 1
            @law = Law.find_by_law_content_id(id.to_i)
            unless @law
              return render_404_json
            end
            result << { id: @law.law_content_id, title: @law.title, pub_date: @law.pub_date, type_name: @law.law_type_name }
          else
            @case = Case.find_by_case_content_id(id.to_i)
            unless @case
              return render_404_json
            end
            result << { id: @case.case_content_id, title: @case.title, pub_date: @case.created_at.try(:strftime,'%Y-%m-%d'), 
                        type_name: @case.law_type_name }
          end # if
        end # each
        
        if result.empty?
          return render_404_json
        end
        
        render_success_with_data(result)
      end
      
      # 收藏
      params do
        requires :token, type: String, desc: "认证token"
        requires :content, type: String, desc: "收藏的内容"
      end
      post '/favorite' do
        user = authenticate!
        
        content = params[:content]
        unless content
          return render_error_json_no_data(2002, '收藏的内容不能为空')
        end
        
        f = Favorite.find_by_user_id(user.id)
        if f.blank?
          Favorite.create!(content: content, user_id: user.id)
        else
          f.content = content
          f.save!
        end
        
        render_success
      end
    end
  end
end