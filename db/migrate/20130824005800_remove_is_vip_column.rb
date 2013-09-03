class RemoveIsVipColumn < ActiveRecord::Migration
  def up
    remove_column :users, :is_vip
    add_column :users, :vip_expired_at, :datetime
  end

  def down
  end
end
