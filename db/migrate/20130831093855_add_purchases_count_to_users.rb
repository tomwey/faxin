class AddPurchasesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :purchases_count, :integer, :default => 0
  end
end
