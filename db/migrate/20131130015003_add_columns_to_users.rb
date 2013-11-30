# coding: utf-8
class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :registered_os, :string # android, iphone, 其他
    add_column :users, :last_logined_at, :datetime
    add_column :users, :last_logined_os, :string # android, iphone, 其他
  end
end
