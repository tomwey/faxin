class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :content
      t.integer :user_id
      
      t.timestamps
    end
    
    add_index :purchases, :user_id
  end
end
