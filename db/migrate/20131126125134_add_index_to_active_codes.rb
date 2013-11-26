class AddIndexToActiveCodes < ActiveRecord::Migration
  def change
    add_index :active_codes, :code, :unique => true
  end
end
