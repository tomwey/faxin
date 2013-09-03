class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.string :keyword
      t.integer :law_type_id
      t.integer :search_count, :default => 0

      t.timestamps
    end
    
    add_index :search_histories, :law_type_id
    add_index :search_histories, :search_count
    
  end
end
