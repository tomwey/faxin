# coding: utf-8
class Purchase < ActiveRecord::Base
  attr_accessible :content, :receipt, :user_id
  
  validates_presence_of :content
  validates_presence_of :receipt
  
  belongs_to :user, :counter_cache => true
  
end
