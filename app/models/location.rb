class Location < ActiveRecord::Base
  attr_accessible :name
  
  has_many :laws
  
  def self.all_locations
    Location.all.map { |loc| [loc.name, loc.id] }
  end
end
