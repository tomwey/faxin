class DeviceInfo < ActiveRecord::Base
  attr_accessible :month_count, :udid, :vip_expired_at
  
  def update_vip_status(count)
    self.vip_expired_at ||= Time.zone.now
    self.vip_expired_at = self.vip_expired_at + count.month
    self.save!
  end
  
  def as_json(options)
    {
      udid: self.udid,
      is_vip: self.is_vip,
      expired_at: self.device_info_expired_at
    }
  end
  
  def device_info_expired_at
    time = if self.vip_expired_at.blank?
      ''
    else
      self.vip_expired_at.strftime('%Y-%m-%d')
    end
    time
  end
  
  def is_vip
    if self.vip_expired_at.nil?
      return false
    end
    return Time.zone.now < self.vip_expired_at
  end
  
end
