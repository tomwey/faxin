class ChangeContentLengthForJudgePaperContents < ActiveRecord::Migration
  def up
    change_column :judge_paper_contents, :content, :text, :limit => 16777215
  end

  def down
  end
end
