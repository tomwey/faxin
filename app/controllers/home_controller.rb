class HomeController < ApplicationController
    before_filter :require_admin  
  def index
    @search = SearchHistory.order('search_count desc').first
    @searches = SearchHistory.group(:law_type_id).sum(:search_count)
    @laws = Law.group(:law_type_id).sum(:visit_count)
    @law = Law.unscoped.order('visit_count desc').first
    @case = Case.unscoped.order('visit_count desc').first
  end
end
