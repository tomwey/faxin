# coding:utf-8
class InviteMailer < ActionMailer::Base
  default :from => "法信-法律图书馆 <no-reply@kekestudio.com>"
  
  def send_code(invite)
    @invite = invite
    mail :to => invite.invitee_email, :subject => "您的朋友邀请您加入《法信-法律图书馆》" do |format|
      format.html { render layout: false }
    end
  end
end