class CreateExtLaws < ActiveRecord::Migration
  def change
    create_table :ext_laws do |t|
      t.string :content
      t.integer :law_type
      t.integer :law_id
      t.integer :source_type
      t.integer :source_id

      t.timestamps
    end
    add_index :ext_laws, :law_id
    add_index :ext_laws, :source_id
    add_index :ext_laws, :source_type
  end
end
