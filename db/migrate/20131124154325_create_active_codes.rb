class CreateActiveCodes < ActiveRecord::Migration
  def change
    create_table :active_codes do |t|
      t.string :code
      t.integer :month_count
      t.integer :user_id
      t.boolean :is_valid, :default => true
      t.datetime :actived_at
      t.boolean :is_buyed, :default => false # 是否已经购买了
      t.boolean :is_unbuyed, :default => false # 是否已经退货
      t.datetime :buyed_at # 确认购买的时间
      t.datetime :unbuyed_at # 退货时间

      t.timestamps
    end
  end
end
