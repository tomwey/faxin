class FavoriteVersion < ActiveRecord::Base
  attr_accessible :folder_version, :user_id, :version
end
