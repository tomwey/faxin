class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string  :email, :null => false, :unique => true
        t.string  :password_digest, :default => "", :null => false     # 发布单位
        t.string  :private_token

        t.timestamps
      end
      
      add_index :users, :email
      add_index :users, :private_token
  end
end
