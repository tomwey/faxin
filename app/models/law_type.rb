class LawType < ActiveRecord::Base
  attr_accessible :name
  
  has_many :laws
  has_many :favorites
  
  def self.all_types
    types = []
    LawType.all.each do |type|
      if type.id != 3
        types << [type.name, type.id]
      end
    end
    types
  end
  
end
