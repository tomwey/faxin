# coding: utf-8
class User < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  validates_presence_of :password, length: { minimum: 6 }, on: :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  has_secure_password
  
  # attr_accessible :title, :body
  attr_protected :is_vip, :private_token
  
  has_many :purchases, :dependent => :destroy
  
  
  VERIFY_SANDBOX = 'https://sandbox.itunes.apple.com/verifyReceipt'
  VERIFY_PRODUCTION = 'https://buy.itunes.apple.com/verifyReceipt'
  
  # 购买确认
  def verify(url, receipt, bid, count)

    RestClient.post(url, { 'receipt-data' => receipt }.to_json, :content_type => :json ) { |response, request, result, &block|
      puts 'status:' + response.code.to_s
      case response.code
      when 200
        result = JSON.parse(response)
        puts 'verify code ' + result['status'].to_s 
        code = result['status'].to_i
        if code == 21007
          puts VERIFY_SANDBOX
          self.verify(VERIFY_SANDBOX, receipt, bid, count)
        elsif code == 0
          # puts 'bid:' + result.to_s
          if result['receipt']['bid'] == bid.to_s
            self.update_vip_status(count)
            Purchase.create(:content => count, :user_id => self.id, :receipt => receipt)
            { code: 200, message: 'verify ok', data: { email: self.email, is_vip: self.is_vip, vip_expired_at: self.vip_expired_at } }
          else
            { code: 500, message: 'bundle id 不正确' }
          end
        else
          { code: 500, message: '凭证无效' }
        end
      else
        puts 'verify failure ' + response.code.to_s
        { code: 500, message: 'verify failure' }
      end
    }
    
  end
  
  # 发送重置密码邮件
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.reset_password(self).deliver
  end
  
  # 更新密码
  def update_with_password(params = {})
    if !params[:old_password].blank? or !params[:password].blank? or !params[:password_confirmation].blank?
      if params[:password] != params[:password_confirmation]
        return false
      elsif User.find_by_email(email).try(:authenticate, params[:old_password])
        update_attribute(:password, params[:password])
        return true
      else
        return false
      end
    else
      # 什么也没输入的时候，成功返回
      return true
    end
  end
  
  def generate_token(column)  
      begin  
        self[column] = SecureRandom.hex(3)  
      end while User.exists?(column => self[column])  
  end
  
  # 重新生成private_token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update_attribute(:private_token, random_key)
  end
  
  def ensure_private_token!
    self.update_private_token if self.private_token.blank?
  end
  
  # 更新vip状态
  def update_vip_status(count)
    self.vip_expired_at ||= Time.zone.now
    self.vip_expired_at = self.vip_expired_at + count.month
    self.save!
  end
  
  def is_vip
    if self.vip_expired_at.nil?
      return false
    end
    return Time.zone.now < self.vip_expired_at
  end
  
end