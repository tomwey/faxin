class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table 'lawyer_types_lawyers', id: false do |t|
      t.belongs_to :lawyer
      t.belongs_to :lawyer_type
    end
  end
end
