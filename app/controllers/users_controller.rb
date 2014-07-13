# coding: utf-8
class UsersController < ApplicationController
  def index
    @users = User.order('created_at DESC').paginate :page => params[:page], :per_page => 30
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def search
    @users = User.where("email like ?", "%#{params[:q]}%").paginate :page => params[:page], :per_page => 30
    render :index
  end
  
  def update
    @user = User.find(params[:id])
    month = params[:month].to_i
    @user.update_vip_status(month)
    redirect_to users_path, :notice => "Update success."
  end
end
