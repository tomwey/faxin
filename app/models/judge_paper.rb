# coding: utf-8
class JudgePaper < ActiveRecord::Base
  attr_accessible :content_id, :court, :summary, :title, :type_id
  
  attr_protected :content_id
  
  belongs_to :judge_paper_content
  
  delegate :content, :to => :judge_paper_content, :allow_nil => true
  
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
    
    integer :content_id
  end
  
  after_save :update_content_id
  def update_content_id
    if self.content_id != self.judge_paper_content.id
      self.content_id = self.judge_paper_content.id
    end
  end
  
  def content=(value)
    self.judge_paper_content ||= JudgePaperContent.new
    self.judge_paper_content.content = value
  end
  
  def update_case(param_hash)
    self.transaction do
      update_attributes!(param_hash)
      judge_paper_content.save!
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
  
  def as_json(opt)
    {
      id: self.content_id,
      title: self.title || "",
      pub_date: self.commited_at.strftime('%Y-%m-%d'),
      type_name: self.law_type_name
    }
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
  
  def self.latest(id, type_id)
      where('content_id > ? and type_id = ?', id, type_id).order('content_id desc')
  end
  
  def self.more(id, type_id)
    where('content_id < ? and type_id = ?', id, type_id).order('content_id desc')
  end
  
end
