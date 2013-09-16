# coding:utf-8
class UserMailer < ActionMailer::Base
  default :from => Settings.email_sender
  
  def reset_password(user)
    @user = user
    mail :to => user.email, :subject => "获取密码重置验证码"
  end
end