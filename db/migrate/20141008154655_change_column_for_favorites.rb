class ChangeColumnForFavorites < ActiveRecord::Migration
  def change
    rename_column :favorites, :operation_method, :state
  end
end
