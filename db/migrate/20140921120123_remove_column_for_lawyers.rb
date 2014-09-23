class RemoveColumnForLawyers < ActiveRecord::Migration
  def change
    remove_column :lawyers, :is_authorized
  end
end
