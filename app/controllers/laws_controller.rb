class LawsController < ApplicationController
  def index
    @laws = Law.limit(50).order('created_at DESC').includes(:law_type).paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @law = Law.find(params[:id])
  end
  
  def new
    @law = Law.new
  end
  
  def create
    @law = Law.new(params[:law])
    if @law.save
      redirect_to @law, :notice => "Successfully created."
    else
      render :new
    end
  end
  
  def edit
    @law = Law.find(params[:id])
  end
  
  def update
    @law = Law.find(params[:id])
    if @law.update_law(params[:law])
      redirect_to @law, :notice => "Successfully updated."
    else
      render :edit
    end
  end
  
  def destroy
    @law = Law.find(params[:id])
    @law.law_content.destroy
    @law.destroy
    redirect_to laws_url
  end
  
end
