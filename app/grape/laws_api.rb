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
          return render_error_json(2004, 'm值不正确，应该为0或1')
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
        
        render_success_with_body(body())
        
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
          return render_error_json(2004, 'm值不正确，应该为0或1')
        end
      
        t = params[:type_id].to_i.zero? ?  1 : params[:type_id].to_i
        
        
        @law = LawType.find_by_id(t)
        unless @law
          return render_error_json(2006, '没有该法律类别')
        end
        
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
        
        if @laws.empty?
          return render_404_json
        end
        
        present @laws, :with => APIEntities::LawDetail
      
        render_success_with_body(body())
        
      end
      
      # 获取法律正文
      params do
        optional :type_id, type: Integer, desc: "类别id"
      end
      get '/:id/body' do
        tid = params[:type_id].to_i
        tid = tid.zero? ? 3 : tid
        
        if not (tid == 1 or tid == 4)
          user = authenticate!
          if not user.try(:is_vip)
            return render_error_json(2005, "还不是vip用户")
          end
        end
        
        id = params[:id].to_i
        @content = LawContent.includes(:law).find_by_id(id)
        if @content.blank?
          return render_404_json
        end
        { code: 0, message: 'ok', data: { law_info: @content.law.as_json(:only => [:summary, :pub_dept, :impl_date]),
            body: @content.content} }
      end
      
      # 获取扩展
      params do
        requires :st, type: Integer, desc: "类别id"
      end
      get '/:id/extensions' do
        st = params[:st].to_i
        if st != 1 and st != 2
          return render_error_json(2004, 'st的值不正确，应该为1或2，1表示法律法规，2表示判例')
        end
        @exts = ExtLaw.where('source_id = ? and source_type = ?', params[:id].to_i, st).order('law_id desc')
        if @exts.empty?
          return render_404_json
        end
        
        present @exts, :with => APIEntities::ExtLawDetail
        
        render_success_with_body(body())
        
      end
      
    end # laws
    
  end
end