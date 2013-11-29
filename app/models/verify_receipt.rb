# coding: utf-8
class VerifyReceipt
  
  VERIFY_SANDBOX_URL = 'https://sandbox.itunes.apple.com/verifyReceipt'
  VERIFY_PRODUCTION_URL = 'https://buy.itunes.apple.com/verifyReceipt'
  
  def self.verify(url, receipt, month_count, bid, device_info)
    RestClient.post(url, { 'receipt-data' => receipt }.to_json, :content_type => :json ) { |response, request, result, &block|
      puts 'status:' + response.code.to_s
      case response.code
      when 200
        result = JSON.parse(response)
        puts 'verify code ' + result['status'].to_s 
        code = result['status'].to_i
        if code == 21007
          puts VERIFY_SANDBOX_URL
          self.verify(VERIFY_SANDBOX_URL, receipt, month_count, bid, device_info)
        elsif code == 0
          # puts 'bid:' + result.to_s
          if result['receipt']['bid'] == bid.to_s
            device_info.update_vip_status(month_count)
            Purchase.create(:content => month_count, :device_info_id => device_info.id, :receipt => receipt)
            # render_success_with_data(self)
            { code: 0, message: 'ok', data: device_info }
          else
            # render_error_json_no_data(3003, '购买的条目所属应用的bundle id不正确')
            { code: 3003, message: '购买的条目所属应用的bundle id不正确' }
          end
        else
          # render_error_json_no_data(3004, '购买凭证无效')
          { code: 3004, message: '购买凭证无效' }
        end
      else
        puts 'verify failure ' + response.code.to_s
        # render_error_json_no_data(3005, "未知原因的验证购买失败, error code:#{response.code.to_s}")
        { code: 3005, message: '未知原因的验证购买失败' }
      end
    }
  end
end