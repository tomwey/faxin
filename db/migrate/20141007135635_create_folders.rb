class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :user_id
      t.integer :version

      t.timestamps
    end
    
    add_index :folders, :user_id
  end
end
