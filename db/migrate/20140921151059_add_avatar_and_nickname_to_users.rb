class AddAvatarAndNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :nickname, :string
  end
end
