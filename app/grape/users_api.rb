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
        expired_at = user.vip_expired_at
        if expired_at.present?
          expired_at = expired_at.strftime('%Y-%m-%d')
        end
        { code: 200, message: 'ok', data: { email: user.email, is_vip: user.is_vip, vip_expired_at: expired_at } }
      end
    end
    
    ######################## 注册登录相关API ################################
    resource "account" do
      # 注册
      params do
        requires :email, type: String, desc: "邮箱"
        requires :password, type: String, desc: "密码"
      end
      post '/' do
        
        user = User.find_by_email(params[:email])
        if user.present?
          return render_error_json(100, '用户已经存在')
        end
        
        if params[:password].length < 6
          return render_error_json(101, '密码长度不应该小于6位')
        end
        
        @user = User.new(email:params[:email], password:params[:password], password_confirmation: params[:password])
        if @user.save
          warden.set_user(@user)
          @user.ensure_private_token!
          { code: 200, message: 'ok', data: { email: @user.email, token: @user.private_token, is_vip: @user.is_vip, expired_at: user.vip_expired_at } }
        else
          render_error_json(400, '注册失败')
        end        
      end
      
      # 登录
      params do
        requires :email, type: String, desc: "邮箱"
        requires :password, type: String, desc: "密码"
      end
      post '/login' do
        user = warden.authenticate(:password)
        if user
          user.update_private_token
          { code: 200, message: 'ok', data: { email: user.email, token: user.private_token, is_vip: user.is_vip, expired_at: user.vip_expired_at } }
        else
          { code: 422, message: '登录失败' }
        end
      end
      
      # 退出登录
      params do
        requires :token, type: String
      end
      post '/logout' do
        authenticate!
        # error!(render_error_json(401, "您已经退出登录了"), 401) unless warden.user
        
        warden.logout
        { code: 200, message: "ok" }
      end
      
      # 忘记密码
      params do
        requires :email, type: String, desc: "邮箱"
      end
      post '/password/forget' do
        user = User.find_by_email(params[:email])
        unless user
          return render_error_json(404, '用户不存在')
        end
        user.send_password_reset
        { code: 200, message: 'ok' }
      end
      
      # 重置密码
      params do
        requires :code, type: String, desc: "验证码"
        requires :password, type: String, desc: "密码"
        requires :password_confirmation, type: String, desc: "确认密码"
      end
      post '/password/reset' do
        @user = User.find_by_password_reset_token!(params[:code])
        if @user.password_reset_sent_at < 2.hours.ago
          render_error_json(105, '验证码已过期')
        elsif params[:password] != params[:password_confirmation]
          render_error_json(106, '两次输入密码不一致')
        elsif @user.update_attribute(:password, params[:password])
          { code: 200, message: 'ok' }
        else
          render_error_json(107, '重置密码失败')
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
        if params[:password] != params[:password_confirmation]
          render_error_json(106, '两次输入密码不一致')
        elsif user.update_with_password(params)
          { code: 200, message: 'ok' }
        else
          render_error_json(400, '密码修改失败')
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
            # puts { id:@law.law_content_id, title:@law.title, pub_date:@law.pub_date, type_name:@law.law_type_name }
            result << { id: @law.law_content_id, title: @law.title, pub_date: @law.pub_date, type_name: @law.law_type_name }
          else
            @case = Case.find_by_case_content_id(id.to_i)
            result << { id: @case.case_content_id, title: @case.title, pub_date: @case.created_at.strftime('%Y-%m-%d'), 
                        type_name: @case.law_type_name }
          end # if
        end # each
        
        if result.empty?
          return render_404_json
        end
        
        { code: 200, message: 'ok', data: result }
        
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
          return render_error_json('400', '收藏的内容不能为空')
        end
        
        f = Favorite.find_by_user_id(user.id)
        f.content = content
        f.save!
        { code: 200, message: "ok" }
      end
    end
  end
end