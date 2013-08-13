class CreateLawContents < ActiveRecord::Migration
  def change
    create_table :law_contents do |t|
      t.text :content, :null => false # 法律详细

      t.timestamps
    end
  end
end
