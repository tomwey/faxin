class LawTypesController < ApplicationController
  def index
    @law_types = LawType.all
  end
  
  def new
    @law_type = LawType.new
  end
end
