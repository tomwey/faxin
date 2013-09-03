class Anyou < ActiveRecord::Base
  attr_accessible :cases_count, :name, :parent_id
  
  has_many :cases
  has_many :children, class_name: 'Anyou', :foreign_key => 'parent_id'
  belongs_to :parent, class_name: 'Anyou'
end
