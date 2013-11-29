class CreateDeviceInfos < ActiveRecord::Migration
  def change
    create_table :device_infos do |t|
      t.string :udid
      t.datetime :vip_expired_at
      t.integer :month_count, :default => 0

      t.timestamps
    end
    
    add_index :device_infos, :udid, :unique => true
  end
end
