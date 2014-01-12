class ChangeContentColumn < ActiveRecord::Migration
  def up
    change_column :law_contents, :content, :text, :limit => 16777215
    change_column :case_contents, :content, :text, :limit => 16777215
  end

  def down
  end
end
