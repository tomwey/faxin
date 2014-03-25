# coding:utf-8
class UserMailer < ActionMailer::Base
   
  default :from => "法信-法律图书馆 <no-reply@kekestudio.com>"
  
  def reset_password(user)
    @user = user
    mail :to => user.email, :subject => "获取密码重置验证码"
  end
  
  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "欢迎加入《法信-法律图书馆》" do |format|
      format.html { render layout: false }
    end
  end
end