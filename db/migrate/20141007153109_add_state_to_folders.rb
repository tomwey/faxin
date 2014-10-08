class AddStateToFolders < ActiveRecord::Migration
  def change
    add_column :folders, :state, :string
    add_column :folders, :visible, :boolean, :default => true
  end
end
