# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class LawsAPI < Grape::API
    
    resources :laws do
      # 新法速递
      params do
        requires :m, type: Integer, desc: '获取数据的模式, 值为0或1, 0为获取新数据, 1为分页加载'
        optional :id, type: Integer, desc: '法律条目ID'
      end
      get '/latest' do
        m = params[:m].to_i
        if not (m == 0 || m == 1)
          return render_error_json(400, 'mode值不正确，应该为0或1')
        end
        
        id = params[:id].to_i
        
        if m == 0
          @laws = Law.includes(:law_type).latest(0,id,0).limit(page_size)
        else
          @laws = Law.includes(:law_type).more(0,id,0).limit(page_size)
        end
        
        if @laws.empty?
          return render_404_json
        end
        
        present @laws, :with => APIEntities::LawDetail
        
        render_json(body())
        
      end
      
      # 分页获取某个类别下面的法律数据
      params do
        requires :type_id, type: Integer, desc: '类别ID'
        requires :m, type: Integer, desc: '获取数据的模式, 值为0或1, 0为获取新数据, 1为分页加载'
        optional :id, type: Integer, desc: '法律条目ID'
        optional :loc_id, type: Integer, desc: '地方ID'
      end
      get '/' do
        
        m = params[:m].to_i
        if not (m == 0 || m == 1)
          return render_error_json(402, 'mode值不正确，应该为0或1')
        end
      
        t = params[:type_id].to_i.zero? ?  1 : params[:type_id].to_i
        
        
        @law = LawType.find_by_id(t)
        if @law.name == '判例'
          redirect "/api/anyous", permanent: true
          return
        end
        
        id = params[:id].to_i
        lid = params[:loc_id].to_i
                
        if m == 0
          @laws = Law.latest(t, id, lid).limit(page_size)
        else
          @laws = Law.more(t, id, lid).limit(page_size)
        end
        present @laws, :with => APIEntities::LawDetail
      
        render_json(body())
        
      end
      
      # 获取法律正文
      get '/:id/body' do
        id = params[:id].to_i
        @content = LawContent.includes(:law).find_by_id(id)
        { code: 200, message: 'ok', data: { law_info: @content.law.as_json(:only => [:doc_id, :pub_dept, :impl_date]),
            body: @content.content} }
      end
      
      # 获取扩展
      get '/:id/extensions' do
      end
      
    end # laws
    
  end
end