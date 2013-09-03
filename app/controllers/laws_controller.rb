class LawsController < ApplicationController
  def index
    @laws = Law.limit(50).order('created_at DESC').includes(:law_type).paginate :page => params[:page], :per_page => 20
  end
  
  def show
    @law = Law.find(params[:id])
  end
end
