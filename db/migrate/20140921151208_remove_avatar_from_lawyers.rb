class RemoveAvatarFromLawyers < ActiveRecord::Migration
  def up
    remove_column :lawyers, :avatar
  end

  def down
    add_column :lawyers, :avatar, :string
  end
end
