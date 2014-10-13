class AddTypeIdToJudgePapers < ActiveRecord::Migration
  def change
    add_column :judge_papers, :type_id, :integer
    add_index :judge_papers, :type_id
  end
end
