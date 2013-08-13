class CreateCaseContents < ActiveRecord::Migration
  def change
    create_table :case_contents do |t|
      t.text :content

      t.timestamps
    end
  end
end
