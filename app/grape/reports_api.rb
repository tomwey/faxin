# coding: utf-8
module Faxin
  class ReportsAPI < Grape::API
    
    resources "reports" do
      params do
        requires :law_title, type: String, desc: "法律标题"
        requires :law_type_id, type: Integer, desc: "法律类别ID"
        requires :content, type: String, desc: "报告内容"
      end
      post '/' do
        Report.create!(content: params[:content], law_title: params[:law_title], law_type_id: params[:law_type_id].to_i)
        { code: 0, message: 'ok' }
      end
    end
    
  end
end