class CreateJudgePapers < ActiveRecord::Migration
  def change
    create_table :judge_papers do |t|
      t.string :title
      t.string :court
      t.string :summary
      t.string :commited_at
      t.integer :sort
      t.integer :content_id
      t.integer :visit_count, :default => 0
      t.integer :type_id

      t.timestamps
    end
    
    add_index :judge_papers, :commited_at
    add_index :judge_papers, :sort
    add_index :judge_papers, :content_id, :unique => true
    add_index :judge_papers, :type_id
  end
end
