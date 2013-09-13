# coding: utf-8
require 'entities'
require 'helpers'
module Faxin
  class SearchAPI < Grape::API
    
    # 获取热门关键字
    params do
      optional :type_id, type: Integer, desc: "类别ID"
      optional :size, type: Integer, desc: "关键字数量"
    end
    get '/search/hot_keywords' do
      size = params[:size].to_i.zero? ? 20 : params[:size].to_i
      size = [size, 50].min;
      tid = params[:type_id].to_i
      if tid <= 0
        @results = SearchHistory.all_keywords(size)
      else
        @results = SearchHistory.where("law_type_id = ? and keyword != ''",params[:type_id].to_i).order('search_count desc').limit(size)
      end
      if @results.empty?
        return render_404_json
      end
      
      { code: 200, message: 'ok', data: @results}
      
      # present @results, :with => APIEntities::SearchHistoryDetail
      # render_json(body())
    end
    
    # 搜索
    params do
      requires :type_id, type: Integer
      requires :q, type: String
      optional :id, type: Integer
    end
    
    get '/search' do
      
      type_id = params[:type_id].to_i
      
      q = params[:q].strip
      
      unless q.blank?
        sh = SearchHistory.find_or_create_by_law_type_id_and_keyword(type_id, params[:q])
        sh.search
      end
      
      if type_id == 3
        klass = Object.const_get "Case"
        content_id = 'case_content_id'
        order_by_date = 'created_at'
      else
        klass = Object.const_get "Law"
        content_id = 'law_content_id'
        order_by_date = 'pub_date'
      end
      
      id = params[:id].to_i
      
      @search = klass.search do
        
        adjust_solr_params do |sunspot_params|
            sunspot_params[:rows] = page_size
        end
        
        fulltext q
        with(:law_type_id, type_id) if type_id != 3
        with(content_id.to_sym).less_than(id) if id > 0
        # order_by order_by_date.to_sym, :desc
        order_by content_id.to_sym, :desc
      end
      
      @results = @search.results
      if @results.empty?
        return render_404_json
      end
      
      if type_id == 3
        present @results, :with => APIEntities::CaseDetail
      else
        present @results, :with => APIEntities::LawDetail
      end
      
      json = { total: @search.total, result: body() }
      
      render_json(json)
      
    end

  end
end