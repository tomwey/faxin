class CasesController < ApplicationController
  def index
    @cases = Case.order('created_at DESC').paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @case = Case.find(params[:id])
  end
end
