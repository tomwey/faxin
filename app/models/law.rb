class Law < ActiveRecord::Base
  attr_accessible :doc_id, :expire_date, :impl_date, :law_type_id, :location_id, :pub_date, :pub_dept, :summary, :title
  
  attr_protected :law_content_id
  
  belongs_to :law_type, counter_cache: true
  belongs_to :location, counter_cache: true
  belongs_to :law_content
  
  delegate :content, to: :law_content, :allow_nil => true
end
