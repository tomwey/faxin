class AddReceiptIsValidToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :receipt_is_valid, :boolean, :default => false
  end
end
