class CreateLawTracks < ActiveRecord::Migration
  def change
    create_table :law_tracks do |t|
      t.string :title
      t.string :pub_date
      t.integer :law_track_content_id

      t.timestamps
    end
    
    add_index :law_tracks, :law_track_content_id
  end
end
