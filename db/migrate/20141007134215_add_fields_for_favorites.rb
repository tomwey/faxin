class AddFieldsForFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :version, :integer, :default => 0
    add_column :favorites, :law_title, :string
    add_column :favorites, :folder_id, :integer
    
    add_index :favorites, :folder_id
    add_index :favorites, :version
  end
end
