# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class CasesAPIV3 < Grape::API    
    
    # 判例资源
    resources :cases do
      # 分页获取某个分类下面的判例
      params do
        requires :m, type: Integer, desc: '获取数据的模式, 值为0或1, 0为获取新数据, 1为分页加载'
        optional :id, type: Integer, desc: "判例ID"
        requires :type_id, type: Integer, desc: "类别ID"
      end
      get '/' do
        m = params[:m].to_i
        if not (m == 0 || m == 1)
          return render_error_json(2004, 'm值不正确，应该为0或1')
        end
        
        id = params[:id].to_i
        type_id = params[:type_id].to_i
        
        if m == 0
          @cases = JudgePaper.latest(id, type_id).limit(page_size)
        else
          @cases = JudgePaper.more(id, type_id).limit(page_size)
        end
      
        if @cases.empty?
          return render_404_json
        end
      
        render_success_with_data(@cases)
      end
      
      # 获取判例正文
      params do
        requires :token, type: String, desc: "认证token"
      end
      get '/:id/body' do        
        user = authenticate!
        if not user.try(:is_vip)
          return render_error_json(2005, "还不是vip用户")
        end
        
        id = params[:id].to_i
        
        @case = JudgePaper.find_by_content_id(id)
        @case.try(:visit)
        
        @content = JudgePaperContent.find_by_content_id(id)
        if @content.blank?
          return render_404_json
        end
        
        render_success_with_data({ body: @content.content })
      end
    end
    
  end
end