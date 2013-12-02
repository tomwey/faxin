# coding: utf-8
module Faxin
  module APIHelpers
    
    def warden
      env['warden']
    end
    
    def current_user
      token = params[:token]
      @current_user ||= User.where(:private_token => token).first
    end
    
    def max_page_size
      100
    end
    
    def default_page_size
      15
    end
    
    def current_page
      page = params[:page].to_i
      page.zero? ? 1 : page
    end
    
    def page_size
      size = params[:size].to_i
      [size.zero? ? default_page_size : size, max_page_size].min
    end
    
    def user_agent
      return (request.env['HTTP_USER_AGENT'] || "other").downcase
    end
    
    def is_android?
      return user_agent.match(/android/)
    end
    
    def is_iphone?
      return user_agent.match(/iphone/)
    end
    
    # 获取操作系统名称
    def os_name
      os_name = ''
      if is_android?
        os_name = 'android'
      elsif is_iphone?
        os_name = 'iphone'
      end
      puts os_name
      os_name
    end
    
    def render_json(data)
      body ( { code: 0, message:'ok', data:data } )
    end
    
    def render_success
      { code: 0, message: 'ok' }
    end
    
    def render_success_with_data(data)
      { code: 0, message: 'ok', data: data }
    end
    
    def render_success_with_body(data)
      body ( { code: 0, message:'ok', data: data } )
    end
    
    def render_404_json
      render_error_json(2001, '数据为空')
    end
    
    def render_error_json(code, message)
      { code: code, message: message, data: [] }
    end
    
    def render_error_json_no_data(code, message)
      { code: code, message: message }
    end
    
    def authenticate!
      user = current_user
      error!(render_error_json_no_data(1006, "你已经下线请重新登录"), 200) unless user
      return user
    end
  end
end