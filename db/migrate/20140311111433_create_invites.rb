# coding: utf-8
class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code                            # 邀请码
      t.string :invitee_email                   # 被邀请人的邮箱
      t.integer :user_id                        # 用户ID
      t.boolean :is_actived, :default => false  # 邀请码是否激活，邀请码只能用一次

      t.timestamps
    end
    add_index :invites, :user_id
    add_index :invites, :code, :unique => true
  end
end
