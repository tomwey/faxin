# coding: utf-8
class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.order('created_at DESC').paginate :page => params[:page], :per_page => 30
  end
end
