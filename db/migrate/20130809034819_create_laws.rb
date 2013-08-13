class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
      t.string  :title
      t.string  :pub_dept     # 发布单位
      t.string  :doc_id       # 发布文号
      t.string  :pub_date     # 发布日期
      t.string  :impl_date    # 生效日期
      t.string  :expire_date  # 失效日期
      t.text    :summary      # 摘要
      t.integer :law_type_id
      t.integer :location_id
      t.integer :law_content_id

      t.timestamps
    end
    
    add_index :laws, :law_type_id
    add_index :laws, :location_id
    add_index :laws, :law_content_id, :unique => true
  end
end
