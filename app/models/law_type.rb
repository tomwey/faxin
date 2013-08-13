class LawType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :laws
end
