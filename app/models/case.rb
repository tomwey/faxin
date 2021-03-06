# coding: utf-8
class Case < ActiveRecord::Base
  attr_accessible :anyou_id, :case_type, :court, :summary, :title

  attr_protected :case_content_id
  
  belongs_to :anyou, :counter_cache => true
  belongs_to :case_content
  
  delegate :content, :to => :case_content, :allow_nil => true
  delegate :name, :to => :anyou, :allow_nil => true, :prefix => true
  
  def law_type_name
    return '判例'
  end
  
  searchable do
    text :title, :boost => 5, :stored => true
    text :content, :boost => 3
    text :court, :boost => 2
    text :summary, :boost => 1
    
    text :pub_time1
    text :pub_time2
    
    text :pub_month1
    text :pub_month2
    
    time :created_at
    # string :publish_date
    
    integer :case_content_id
  end
  
  after_save :update_content_id
  def update_content_id
    if self.case_content_id != self.case_content.id
      self.case_content_id = self.case_content.id
    end
  end
  
  def content=(value)
    self.case_content ||= CaseContent.new
    self.case_content.content = value
  end
  
  def update_case(param_hash)
    self.transaction do
      update_attributes!(param_hash)
      case_content.save!
      save!
    end
  rescue
    return false
  end
  
  
  def pub_time1
    if created_at
      created_at.to_time.strftime("%Y-%m-%d")
    end
  end
  
  def pub_time2
    if created_at
      created_at.to_time.strftime("%Y%m%d")
    end
  end
  
  def pub_month1
    if created_at
      created_at.to_time.strftime("%Y-%m")
    end
  end
  
  def pub_month2
    if created_at
      created_at.to_time.strftime("%Y%m")
    end
  end
  
  def visit
    self.class.increment_counter(:visit_count, self.id)
  end
  
  # def publish_date
  #   if created_at
  #     created_at.to_time.strftime('%Y-%m-%d')
  #   end
  # end
  
  default_scope order('created_at desc')
  
  def self.latest(id)
      where('case_content_id > ?', id).order('case_content_id desc')
  end
  
  def self.more(id)
    where('case_content_id < ?', id).order('case_content_id desc')
  end
  
end
