# coding: utf-8
class Invite < ActiveRecord::Base
  attr_accessible :code, :invitee_email, :is_actived, :user_id
  
  validates_presence_of :code, :invitee_email, :user_id, :if => :create
  validates_uniqueness_of :code
  
  belongs_to :user, :counter_cache => true
  
  before_create :generate_code
  def generate_code
    # self.code = loop do
    #   random_token = SecureRandom.base64(5).tr('+/=', '0aZ').strip.delete("\n")
    #   break random_token unless self.class.exists?(code: random_token)
    # end
    self.code = SecureRandom.base64(5).tr('+/=', '0aZ').strip.delete("\n")
  end
  
  after_create :send_email
  def send_email
    InviteMailer.send_code(self).deliver
  end
  
end
