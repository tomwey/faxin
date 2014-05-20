class AddColumns < ActiveRecord::Migration
  def up
    add_column :favorites, :law_type_id, :integer
    add_column :favorites, :law_article_id, :integer
    # 数据操作方式值为A, M, D
    add_column :favorites, :operation_method, :string, :default => 'A'
    add_column :favorites, :visible, :boolean, :default => true
    # 1表示收藏部分文字, 2表示收藏全文
    add_column :favorites, :favorite_type, :integer, :default => 1 
    add_column :favorites, :favorited_at, :datetime
    
    add_index :favorites, :law_type_id
    add_index :favorites, :law_article_id
    add_index :favorites, :favorited_at
  end

  def down
    remove_column :favorites, :law_type_id
    remove_column :favorites, :law_article_id
    remove_column :favorites, :operation_method
    remove_column :favorites, :visible
    remove_column :favorites, :favorite_type
    remove_column :favorites, :favorited_at
    
    remove_index :favorites, :law_type_id
    remove_index :favorites, :law_article_id
    remove_index :favorites, :favorited_at
  end
end
