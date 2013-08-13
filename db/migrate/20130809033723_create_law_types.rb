class CreateLawTypes < ActiveRecord::Migration
  def change
    create_table :law_types do |t|
      t.string :name
      t.integer :laws_count, :default => 0
      t.timestamps
    end
  end
end
