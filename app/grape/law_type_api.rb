# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class LawTypeAPI < Grape::API
    
    # 法律类别资源
    resources :law_types do
      # 获取所有的法律类别
      get '/' do
        @law_types = LawType.order('id asc')
        unless @law_types
          return render_404_json
        end
        
        present @law_types, with: APIEntities::LawType
        render_success_with_body(body())
      end
      
      #1,12:2,22:3,33:4,44:5,45
      params do
        requires :data, type: String, desc: "当前的类别数据"
      end
      
      get '/latest' do
        data = params[:data]
        if data.blank?
          return render_error_json_no_data(2003, '参数值为空')
        end
        
        arr = data.split(':') 
        result = []
        arr.each do |id|
          tid, lid = id.split(',')
          tid = tid.to_i
          lid = lid.to_i
          
          hash = {}
          
          if lid <= 0
            count = 0
          else
            if tid == 3
              count = Case.where('case_content_id > ?', lid).count
            else
              count = Law.where('law_content_id > ? and law_type_id = ?', lid, tid).count
            end
          end
          
          result << { :type_id => tid, :count => count }
        end
        
        if result.empty?
          return render_404_json
        end
        
        render_success_with_data(result)
        
      end
    end
    
  end
end