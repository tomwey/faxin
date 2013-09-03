class LawContent < ActiveRecord::Base
  attr_accessible :content
  
  has_one :law
end
