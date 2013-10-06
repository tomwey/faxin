# coding: utf-8
class SessionsController < ApplicationController
  layout "login"
  skip_before_filter :authenticate!
  
  def new
    flash.now.alert = warden.message if warden.message.present?
  end
  
  def create
    warden.authenticate!
    redirect_to root_url, notice: "登录成功!"
  end
  
  def destroy
    warden.logout
    redirect_to root_url, notice: "退出登录!"
  end
end