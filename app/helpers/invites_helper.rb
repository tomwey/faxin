# coding: utf-8
module InvitesHelper
  def render_invite_user_name(invite)
    invite.user.try(:email)
  end
  
  def render_invite_active_status(invite)
    invite.is_actived ? "Yes" : "No" 
  end
  
end