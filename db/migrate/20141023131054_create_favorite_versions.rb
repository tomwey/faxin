class CreateFavoriteVersions < ActiveRecord::Migration
  def change
    create_table :favorite_versions do |t|
      t.integer :user_id
      t.integer :folder_version, default: 0
      t.integer :version, default: 0

      t.timestamps
    end
    add_index :favorite_versions, :user_id
  end
end
