# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class ActiveAPI < Grape::API
    # 激活码购买
    resource :code do
      params do
        requires :code, type: String, desc: "激活码"
        requires :token, type: String, desc: '认证token'
      end
      post '/active' do
        # 首先需要登录
        user = authenticate!
        
        ac = ActiveCode.find_by_code(params[:code])
        if ac.blank?
          return render_error_json_no_data(4001, '该激活码不存在')
        end
        
        # 没有确认发货
        if not ac.is_shipped?
          return render_error_json_no_data(4002, '该激活码还没确认购买，请稍等')
        end
        
        # 确认该激活码是否有效
        # 激活一次自动失效
        # 退货自动失效
        # TODO: 支持有效期
        if not ac.is_valid
          return render_error_json_no_data(4003, '该激活码已经失效')
        end
        
        # 开始激活
        ac.user_id = user.id
        user.update_vip_status(ac.month_count)
        ac.is_valid = false # 激活一次就失效
        ac.actived_at = Time.zone.now
        if ac.save
          render_success_with_body(user)
        else
          render_error_json_no_data(4004, '激活失败，请稍后再试')
        end
        
      end
    end   
  end
end