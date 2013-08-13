# coding: utf-8
module Faxin
  module APIHelpers
    
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
    
    # def authenticate!
    #   api_key = ApiKey.find_by_access_token(params[:token])
    #     error!(render_error_json(401, "Token不正确"), 401) unless api_key
    # end
  end
end