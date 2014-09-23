class AddStateToLawyers < ActiveRecord::Migration
  def change
    add_column :lawyers, :state, :integer, :default => Lawyer::STATE[:normal]
  end
end
