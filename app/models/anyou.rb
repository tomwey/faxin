class Anyou < ActiveRecord::Base
  attr_accessible :cases_count, :name, :parent_id
  
  has_many :cases
end
