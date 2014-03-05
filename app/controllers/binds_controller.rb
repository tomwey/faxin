# coding: utf-8
class BindsController < ApplicationController
  def index
    @binds = Bind.order('created_at DESC').paginate :page => params[:page], :per_page => 30
  end
  
  def new
    @bind = Bind.new
  end
  
  def create
    @bind = Bind.new(params[:bind])
    if @bind.save
      redirect_to binds_path, :notice => "Created success."
    else
      render :new
    end
  end
  
  def edit
    @bind = Bind.find(params[:id])
  end
  
  def update
    @bind = Bind.find(params[:id])
    if @bind.update_attributes(params[:bind])
      redirect_to edit_bind_path, :notice => "更新成功"
    else
      render :edit
    end
  end
end
