class ChangeColumn < ActiveRecord::Migration
  def up
    change_column :purchases, :content, :Integer
  end

  def down
  end
end
