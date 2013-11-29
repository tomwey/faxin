class AddDeviceInfoIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :device_info_id, :integer
    add_index :purchases, :device_info_id
  end
end
