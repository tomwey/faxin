# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class LawContentAPI < Grape::API
    
    # 根据UDID获取VIP信息
    params do
      requires :udid, type: String, desc: "udid"
      optional :email, type: String, desc: "认证token"
    end
    get '/user/vip_info' do
      user = User.find_by_udid(params[:udid])
      if user.blank?
        user = User.find_by_email(params[:email])
      end
      
      if user.blank?
        render_404_json
      else
        render_success_with_data(user)
      end
    end
    
    #########################################获取法律法规正文#############################################################
    # 获取法律正文
    # params type_id 类别id
    # params token 认证token
    params do
      requires :type_id, type: Integer, desc: "类别id"
      optional :token, type: String, desc: "认证token"
      optional :udid, type: String, desc: "udid"
    end
    get 'laws/:id/detail' do
      tid = params[:type_id].to_i
      if tid == 3
        return render_error_json_no_data(2007, "请求了错误的资源")
      end
      
      if not (tid == 1 or tid == 4) # 类别1和类别4是不需要验证的
        if params[:token].blank? # 表示用户还没有登录或注册
          if params[:udid].blank?
            return render_error_json_no_data(2003, "token参数没有设置，或值为空")
          end
          user = User.find_by_udid(params[:udid])
          if not user.try(:is_vip)
            return render_error_json(2005, "还不是vip用户")
          end
        else
          user = User.find_by_token(params[:token])
          if user.blank?
            return render_error_json_no_data(1006, "您的账号已经下线了")
          end
          if not user.try(:is_vip)
            return render_error_json(2005, "还不是vip用户")
          end
        end
      end
      
      # vip用户
      id = params[:id].to_i
      @content = LawContent.includes(:law).find_by_id(id)
      if @content.blank?
        return render_404_json
      end
      { code: 0, message: 'ok', data: { law_info: @content.law.as_json(:only => [:doc_id, :pub_dept, :impl_date]),
          body: @content.content} }
    end
    
    ###################################################获取判例正文#########################################################
    # 获取判例正文
    params do
      requires :udid, type: String, desc: "udid"
      optional :token, type: String, desc: "认证token"
    end
    get 'cases/:id/detail' do        
      
      if params[:token].blank? # 表示用户还没有登录或注册
        if params[:udid].blank?
          return render_error_json_no_data(2003, "token参数没有设置，或值为空")
        end
        user = User.find_by_udid(params[:udid])
        if not user.try(:is_vip)
          return render_error_json(2005, "还不是vip用户")
        end
      else
        user = User.find_by_token(params[:token])
        if user.blank?
          return render_error_json_no_data(1006, "您的账号已经下线了")
        end
        if not user.try(:is_vip)
          return render_error_json(2005, "还不是vip用户")
        end
      end
      
      id = params[:id].to_i
      @content = CaseContent.find_by_id(id)
      if @content.blank?
        return render_404_json
      end
      
      render_success_with_data({ body: @content.content })
    end
    
  end
end