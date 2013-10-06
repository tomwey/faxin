class Anyou < ActiveRecord::Base
  attr_accessible :cases_count, :name, :parent_id
  
  has_many :cases
  has_many :children, class_name: 'Anyou', :foreign_key => 'parent_id'
  belongs_to :parent, class_name: 'Anyou'
  
  def self.all_anyous
    anyous = Anyou.where(:parent_id => 0)
    subanyous = Anyou.where(:parent_id => anyous.map { |a| a.id } )
    subanyous2 = Anyou.where(:parent_id => subanyous.map { |a| a.id })
    subanyous2.map { |a| [a.name, a.id] }
  end
end
