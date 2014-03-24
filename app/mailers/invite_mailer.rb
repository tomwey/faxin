# coding:utf-8
class InviteMailer < ActionMailer::Base
  default :from => "no-reply@kekestudio.com"
  
  def send_code(invite)
    @invite = invite
    mail :to => invite.invitee_email, :subject => "获取邀请码"
  end
end