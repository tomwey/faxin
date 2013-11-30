class RemoveDeviceInfoIdFromPurchases < ActiveRecord::Migration
  def up
    remove_column :purchases, :device_info_id
  end

  def down
    add_column :purchases, :device_info_id, :integer
    add_index :purchases, :device_info_id
  end
end
