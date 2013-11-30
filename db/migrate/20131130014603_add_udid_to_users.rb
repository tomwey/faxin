class AddUdidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :udid, :string
    add_index :users, :udid, :unique => true
  end
end
