# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class CasesAPI < Grape::API
    
    # 获取所有案由
    get '/anyous' do
      # params do
      #   optional :aid, type: Integer, desc: '案由类别'
      # end
      #     
      # t = params[:aid].to_i.zero? ? 1 : params[:aid].to_i
      #     
      # @anyou = Anyou.find_by_id(t)
      #     
      # unless @anyou.present?
      #   return render_404_json
      # end
      
      @anyous = Anyou.where('parent_id != 0')
    
      # @anyous = @anyou.children
    
      present @anyous, :with => APIEntities::AnyouDetail
      render_json(body())
    
    end
    
    # 判例资源
    resources :cases do
      # 分页获取某个分类下面的判例
      params do
        requires :aid, type: Integer, desc: '案由ID'
        requires :m, type: Integer, desc: '获取数据的模式, 值为0或1, 0为获取新数据, 1为分页加载'
        optional :id, type: Integer, desc: "判例ID"
      end
      get '/' do
        m = params[:m].to_i
        if not (m == 0 || m == 1)
          return render_error_json(400, 'mode值不正确，应该为0或1')
        end
          
        t = params[:aid].to_i.zero? ?  1 : params[:aid].to_i
        id = params[:id].to_i
      
        anyou = Anyou.find_by_id(t)
      
        if anyou.blank?
          return render_404_json
        end
      
        if m == 0
          @cases = anyou.cases.latest(id).limit(page_size)
        else
          @cases = anyou.cases.more(id).limit(page_size)
        end
      
        if @cases.empty?
          return render_404_json
        end
      
        present @cases, :with => APIEntities::CaseDetail
      
        render_json(body())
      end
      
      # 获取判例正文
      get '/:id/body' do
        user = authenticate!
        if not user.try(:is_vip)
          return render_error_json(401, "还不是vip用户")
        end
        id = params[:id].to_i
        @content = CaseContent.find_by_id(id)
        if @content.blank?
          return render_404_json
        end
        { code: 200, message: 'ok', data: { body: @content.content} }
      end
    end
    
  end
end