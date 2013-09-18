class AddReceiptToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :receipt, :text
  end
end
