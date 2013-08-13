class CreateAnyous < ActiveRecord::Migration
  def change
    create_table :anyous do |t| # 案由表
      t.string :name
      t.integer :parent_id
      t.integer :cases_count, :default => 0

      t.timestamps
    end
    
    add_index :anyous, :parent_id
  end
end
