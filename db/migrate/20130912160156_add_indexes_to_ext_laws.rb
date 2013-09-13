class AddIndexesToExtLaws < ActiveRecord::Migration
  def change
    add_index :ext_laws, :law_id
    add_index :ext_laws, :source_id
    add_index :ext_laws, :source_type
  end
end
