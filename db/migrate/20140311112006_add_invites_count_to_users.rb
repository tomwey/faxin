class AddInvitesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invites_count, :integer, :default => 0
  end
end
