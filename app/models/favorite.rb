class Favorite < ActiveRecord::Base
  attr_accessible :content, :user_id, :law_type_id, :law_article_id, :operation_method, :visible, :favorite_type, :favorited_at
                  
  belongs_to :law_type
  
  def as_json(options)
    {
      id: self.id,
      content: self.favorite_content,
      favorited_at: self.favorited_date,
      favorite_type: self.favorite_type,
      article_id: self.law_article_id,
      law_type_id: self.law_type_id
      # law_type: {
      #   id: self.law_type_id,
      #   name: self.law_type_name
      # }
    }
  end
  
  def favorite_content
    self.content || self.favorite_law_title
  end
  
  def favorite_law_title
    if law_type == 3
      @case = Case.select('title').where(:case_content_id => self.law_article_id).first
      return @case.title || ""
    else
      @law = Law.select('title').where(:law_content_id => self.law_article_id).first
      return @law.title || ""
    end
  end
  
  def favorited_date
    self.favorited_at.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def law_type_name
    @type = LawType.find_by_id(self.law_type_id)
    @type.try(:name)
  end
  
end
