# coding: utf-8
module PurchasesHelper
  def render_user_name(purchase)
    if purchase.user.nil?
      return ""
    else
      return purchase.user.email
    end
  end
end