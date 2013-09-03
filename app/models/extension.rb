class Extension < ActiveRecord::Base
  attr_accessible :extended_ids, :extended_type, :extending_id
end
