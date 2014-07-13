class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :law_title
      t.integer :law_type_id
      t.integer :law_id
      t.string :content

      t.timestamps
    end
  end
end
