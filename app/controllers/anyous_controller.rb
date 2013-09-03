class AnyousController < ApplicationController
  def index
    @anyous = Anyou.all
  end
end
