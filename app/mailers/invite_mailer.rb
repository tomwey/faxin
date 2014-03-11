# coding:utf-8
class InviteMailer < ActionMailer::Base
  default :from => "kekestudio@sina.com"
  
  def send_code(invite)
    @invite = invite
    mail :to => invite.invitee_email, :subject => "获取邀请码"
  end
end