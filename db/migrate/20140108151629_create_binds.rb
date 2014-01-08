class CreateBinds < ActiveRecord::Migration
  def change
    create_table :binds do |t|
      t.string :email
      t.string :udid

      t.timestamps
    end
  end
end
