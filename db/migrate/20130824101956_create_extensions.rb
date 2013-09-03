class CreateExtensions < ActiveRecord::Migration
  def change
    create_table :extensions do |t|
      t.integer :extending_id
      t.string :extended_ids
      t.string :extended_type

      t.timestamps
    end
    
  end
end
