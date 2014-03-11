class AddIndexToInvites < ActiveRecord::Migration
  def change
    add_index :invites, :invitee_email
  end
end
