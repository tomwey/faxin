class CreateLawyers < ActiveRecord::Migration
  def change
    create_table :lawyers do |t|
      t.string :real_name
      t.string :avatar
      t.string :lawyer_card # 律师证编号
      t.string :city
      t.string :law_firm    # 律师事务所
      t.string :lawyer_card_image
      t.string :mobile
      t.text   :intro
      t.boolean :is_authorized, default: false

      t.timestamps
    end
    
    add_index :lawyers, :lawyer_card, :unique => true
    add_index :lawyers, :mobile, :unique => true
  end
end
