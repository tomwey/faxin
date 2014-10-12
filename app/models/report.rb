class Report < ActiveRecord::Base
  attr_accessible :content, :law_id, :law_title, :law_type_id
  
  def law_type_name
    LawType.find_by_id(self.law_type_id).try(:name) || ""
  end
end
