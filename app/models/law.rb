class Law < ActiveRecord::Base
  attr_accessible :doc_id, :expire_date, :impl_date, :law_type_id, :location_id, :pub_date, :pub_dept, :summary, :title
  
  attr_protected :law_content_id
  
  belongs_to :law_type, counter_cache: true
  belongs_to :location, counter_cache: true
  belongs_to :law_content
  
  delegate :content, to: :law_content, :allow_nil => true
  delegate :name, :to => :law_type, :allow_nil => true, :prefix => true
  
  scope :recent, order('law_content_id desc')
  
  searchable do
    text :title, :boost => 5, :stored => true
    text :content, :boost => 3, :stored => true
    
    text :pub_time1
    text :pub_time2
    
    text :pub_month1
    text :pub_month2
    
    time :pub_date
    # string :publish_date
    
    integer :law_type_id
    integer :location_id
    integer :law_content_id
  end
  
  def pub_time1
    if pub_date
      pub_date.to_time.strftime("%Y-%m-%d")
    end
  end
  
  def pub_time2
    if pub_date
      pub_date.to_time.strftime("%Y%m%d")
    end
  end
  
  def pub_month1
    if pub_date
      pub_date.to_time.strftime("%Y-%m")
    end
  end
  
  def pub_month2
    if pub_date
      pub_date.to_time.strftime("%Y%m")
    end
  end
  
  
  # default_scope order('pub_date desc')
  
  def self.latest(type_id, id, loc_id)
    if type_id == 0
      where('law_content_id > ?', id).order('law_content_id desc')
    elsif loc_id == 0
      where('law_content_id > ? and law_type_id = ?', id, type_id).order('law_content_id desc')
    else
      where('law_content_id > ? and law_type_id = ? and location_id = ?', id, type_id, loc_id).order('law_content_id desc')
    end
    
  end
  
  def self.more(type_id, id, loc_id)
    if type_id == 0
      where('law_content_id < ?', id).order('law_content_id desc')
    elsif loc_id == 0
      where('law_content_id < ? and law_type_id = ?', id, type_id).order('law_content_id desc')
    else
      where('law_content_id < ? and law_type_id = ? and location_id = ?', id, type_id, loc_id).order('law_content_id desc')
    end
    
  end
  
end
