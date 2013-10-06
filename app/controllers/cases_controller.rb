class CasesController < ApplicationController
  def index
    @cases = Case.order('created_at DESC').paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @case = Case.find(params[:id])
  end
  
  def new
    @case = Case.new
  end
  
  def create
    @case = Case.new(params[:case])
    if @case.save
      redirect_to @case, :notice => "Successfully created"
    else
      render :new
    end
  end
  
  def edit
    @case = Case.find(params[:id])
  end
  
  def update
    @case = Case.find(params[:id])
    if @case.update_case(params[:case])
      redirect_to @case, :notice => "Successfully updated"
    else
      render :edit
    end
  end
  
  def destroy
    @case = Case.find(params[:id])
    @case.case_content.destroy
    @case.destroy
    redirect_to cases_url
  end
  
end
