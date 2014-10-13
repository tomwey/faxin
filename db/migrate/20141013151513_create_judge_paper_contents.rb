class CreateJudgePaperContents < ActiveRecord::Migration
  def change
    create_table :judge_paper_contents do |t|
      t.text :content, :limit => nil
      t.integer :content_id

      t.timestamps
    end
    
    add_index :judge_paper_contents, :content_id, :unique => true
  end
end
