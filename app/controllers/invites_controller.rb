# coding: utf-8
class InvitesController < ApplicationController
  def index
    @invites = Invite.order('created_at DESC').paginate :page => params[:page], :per_page => 30
  end
  
  def new
    @invite = Invite.new
  end
  
  def create
    @invite = Invite.new(params[:invite])
    if @invite.user.nil?
      redirect_to :new, :notice => "邀请者不存在"
      return 
    end
    
    if @invite.save
      redirect_to invites_path, :notice => "Created success."
    else
      render :new
    end
  end
  
  def active
    @invite = Invite.find(params[:id])
    if @invite.present?
      # @invite.is_actived = true
      @invite.update_attribute("is_actived", true)
    end
    redirect_to invites_path, :notice => "Active success."
  end
  
end
