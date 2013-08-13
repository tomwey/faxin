class Case < ActiveRecord::Base
  attr_accessible :anyou_id, :case_type, :court, :summary, :title

  attr_protected :case_content_id
  
  belongs_to :anyou, :counter_cache => true
  belongs_to :case_content
  
end
