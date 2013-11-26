# coding: utf-8
class ActiveCodesController < ApplicationController
  def index
    @active_codes = ActiveCode.paginate :page => params[:page], :per_page => 10
  end
  
  def new
    @active_code = ActiveCode.new
  end
  
  def create
    @active_code = ActiveCode.new(params[:active_code])
    count = @active_code.code_count.to_i
    if count <= 0
      count = 100
    end
    
    codes = []
    count.times do 
      codes << { :code => @active_code, :month_count => @active_code.month_count }
    end
    
    ActiveCode.create!(codes)
    
    redirect_to active_codes_path, :alert => "生成成功!!!"
  end
  
  # 确认购买
  def buy
    ac = ActiveCode.find_by_id(params[:id])
    if ac.present?
      ac.is_buyed = true
      ac.buyed_at = Time.zone.now
      ac.save!
    end
    redirect_to active_codes_path
  end
  
  # 退货
  def unbuy
    ac = ActiveCode.find_by_id(params[:id])
    if ac.present?
      if not ac.actived_at.nil?
        user = ac.user
        ac.unbuyed_at = Time.zone.now
        ac.is_unbuyed = true
        ac.is_valid = false
        count = ac.month_count
        if user.is_vip
          dt = user.vip_expired_at - count.month + 1.day
          user.vip_expired_at = dt
          user.save
        end
        ac.save
      end
    end
    redirect_to active_codes_path
  end
  
  def destroy
    @active_code = ActiveCode.find(params[:id])
    @active_code.destroy
    redirect_to active_codes_url
  end
  
end