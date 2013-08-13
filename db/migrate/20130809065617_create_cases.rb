class CreateCases < ActiveRecord::Migration
  def change
    create_table :cases do |t| # 判例表
      t.string :title
      t.string :court            # 法院名
      t.string :case_type        # 判例类别
      t.string :summary          # 摘要
      t.integer :case_content_id
      t.integer :anyou_id

      t.timestamps
    end
    
    add_index :cases, :case_content_id, :unique => true
    add_index :cases, :anyou_id
  end
end
