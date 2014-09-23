class CreateLawyerTypes < ActiveRecord::Migration
  def change
    create_table :lawyer_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
