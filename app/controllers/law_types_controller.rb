class LawTypesController < ApplicationController
  def index
    @law_types = LawType.all
  end
  
  def show
    @law_type = LawType.find(params[:id])
    @law_type_name = @law_type.name
    @laws = @law_type.laws.unscoped.order('pub_date desc').paginate :page => params[:page], :per_page => 30
  end
  
  def new
    @law_type = LawType.new
  end
end
