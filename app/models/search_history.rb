class SearchHistory < ActiveRecord::Base
  attr_accessible :keyword, :law_type_id, :search_count
  
  def search
    self.class.increment_counter(:search_count, self.id)
  end
  
  def self.all_keywords(size)
    result = {}
    %w(1 2 3 4 5).each do |id|
      @results = self.where('law_type_id = ? and keyword != ""', id).order('search_count desc').limit(size)
      # result << { id.to_sym => @results.map { |s| s.keyword }.join(',') }
      result[id.to_sym] = @results.map { |s| s.keyword }.join(',')
    end
    result
  end
end
