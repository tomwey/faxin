class Favorite < ActiveRecord::Base
  attr_accessible :content, :user_id, :law_type_id, :law_article_id, :state, :visible, :favorite_type, :favorited_at, :law_title, :folder_id
                  
  belongs_to :law_type
  belongs_to :folder
  belongs_to :user
  
  attr_accessor :client_id, :client_folder_id
  
  def as_json(options)
    {
      id: self.id,
      law_title: self.law_title || "",
      favorite_content: self.content || "",
      favorited_at: self.favorited_date,
      favorite_type: self.favorite_type,
      article_id: self.law_article_id,
      state: self.state,
      user_email: self.user.try(:email),
      folder_id: self.folder.id,
      client_id: self.client_id,
      client_folder_id: self.client_folder_id,
      version: self.version
      law_type: {
        id: self.law_type_id,
        name: self.law_type_name
      }
    }
  end
  
  after_create :add_version
  def add_version
    self.class.increment_counter(:version, self.id) if self.visible == true
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
    if self.favorited_at.blank?
      return ""
    end
    return self.favorited_at.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def law_type_name
    @type = LawType.find_by_id(self.law_type_id)
    @type.try(:name)
  end
  
end
