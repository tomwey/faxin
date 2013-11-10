# coding: utf-8
class SearchController < ApplicationController
  # 法律法规
  def index
    type_id = params[:type_id].to_i
    if type_id != 0
      @law_type = LawType.find(type_id)
    end
    
    @search = search(params[:q], type_id)
    @laws = @search.results
    @total = @search.total
    if type_id == 0
      render 'laws/index'
    else
      render 'law_types/show'
    end
  end
  
  # 判例
  def cases
    @search = search(params[:q], 3)
    @cases = @search.results
    @total = @search.total
    render 'cases/index'
  end
  
  private
  
  def search(q,type_id)
    if type_id == 3
      klass = Object.const_get "Case"
      content_id = 'case_content_id'
      order_by_date = 'created_at'
    else
      klass = Object.const_get "Law"
      content_id = 'law_content_id'
      order_by_date = 'pub_date'
    end
    
    # page = params[:page].to_i
    
    @search = klass.search do
      
      # adjust_solr_params do |sunspot_params|
      #     sunspot_params[:rows] = page_size
      # end
      
      fulltext q
      with(:law_type_id, type_id) if (type_id != 3 and type_id != 0)
      order_by :score, :desc
      order_by order_by_date.to_sym, :desc
      order_by content_id.to_sym, :desc
      paginate(:page => params[:page] || 1, :per_page => 30)
    end
    
    return @search
    
  end
  
end
