class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string  :email, :null => false, :unique => true
        t.string  :password_digest, :default => "", :null => false     # 发布单位
        t.string  :private_token
        t.string  :password_reset_token
        t.integer :purchases_count, :default => 0
        t.datetime :password_reset_sent_at
        t.datetime :vip_expired_at

        t.timestamps
      end
      
      add_index :users, :email
      add_index :users, :private_token
      add_index :users, :password_reset_token
  end
end
