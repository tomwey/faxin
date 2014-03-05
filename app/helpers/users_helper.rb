# coding: utf-8
module UsersHelper
  def render_user_tag(user)
    user.udid || user.email
  end
  
  def render_user_expired_at(user)
    user.vip_expired_at || "还不是VIP用户"
  end
  
  def render_user_reg_os(user)
    user.registered_os || "Android"
  end
end