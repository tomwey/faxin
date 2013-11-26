# coding: utf-8
class ActiveCode < ActiveRecord::Base
  attr_accessible :month_count
  attr_protected :user_id
  
  belongs_to :user
  
  validates_presence_of :month_count
  
  attr_accessor :code_count
  
  default_scope order('created_at desc')
  scope :unsaled, where(:is_buyed => false)
  scope :actived, where(:is_valid => false)
  scope :unactived, where(:is_valid => true)
  
  MONTH_COUNTS = [["1个月", 1], ["3个月", 3], ["6个月",6],["12个月",12]]
  
  before_create :generate_code
  def generate_code
    begin  
      self[:code] = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join
    end while ActiveCode.exists?(:code => self[:code])  
  end
  
  def is_shipped?
    return is_buyed
  end
  
end
