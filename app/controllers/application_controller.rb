# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  ADMINS = %w( kekestudio@sina.com tomwey@163.com )
  
  before_filter :authenticate!
  
  private
  
  def current_user
    warden.user
  end
  helper_method :current_user
  
  def warden
    env['warden']
  end
  
  def authenticate!
    unless current_user
      redirect_to :login
      return
    end
  end
  
  def require_admin
    if not ADMINS.include?(current_user.email)
      warden.logout
      render_error
    end
  end
  
  def render_error
    render :template => "/errors/403.html.erb", :status => 403, :layout => false
  end
  
end
