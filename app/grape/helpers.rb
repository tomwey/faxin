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
    
    def render_json(data)
      body ( { code: 200, message:'ok', data:data } )
    end
    
    def render_404_json
      render_error_json(404, '数据为空')
    end
    
    def render_error_json(code, message)
      { code: code, message: message, data: [] }
    end
    
    def authenticate!
      user = current_user
      # error!(render_error_json(401, "Token无效"), 401) unless user
      if user.blank?
        return render_error_json(401, "Token无效"
      end
      return user
    end
  end
end