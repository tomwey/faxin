# coding: utf-8
class Lawyer < ActiveRecord::Base
  attr_accessible :city, :law_firm, :lawyer_card, :real_name, :lawyer_card_image, :mobile, :intro
  
  has_one :user, as: :profile, dependent: :destroy
  
  has_and_belongs_to_many :lawyer_types#, class_name: "LawyerType", :inverse_of => :lawyers
  
  mount_uploader :lawyer_card_image, ImageUploader
  
  validates :real_name, :lawyer_card, :mobile, :law_firm, :city, :intro, presence: true, :on => :create
  
  STATE = {
    deleted:  -1, # 软删除
    normal:    1,  # 默认状态, 未认证
    approving: 2, # 认证中 
    approved:  4,  # 认证成功
    blocked:   8,  # 禁用
  }
  
end
