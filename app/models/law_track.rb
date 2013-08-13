class LawTrack < ActiveRecord::Base
  attr_accessible :pub_date, :title
  
  belongs_to :law_track_content
  
  delegate :content, :to => :law_track_content
end
