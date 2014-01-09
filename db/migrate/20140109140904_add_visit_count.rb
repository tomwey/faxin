class AddVisitCount < ActiveRecord::Migration
  def up
    add_column :laws, :visit_count, :integer, :default => 0
    add_column :cases, :visit_count, :integer, :default => 0
  end

  def down
  end
end
