class Report < ActiveRecord::Base
  attr_accessible :content, :law_id, :law_title, :law_type_id
end
