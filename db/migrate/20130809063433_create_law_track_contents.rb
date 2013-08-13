class CreateLawTrackContents < ActiveRecord::Migration
  def change
    create_table :law_track_contents do |t|
      t.text :content

      t.timestamps
    end
  end
end
