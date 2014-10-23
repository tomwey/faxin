class Folder < ActiveRecord::Base
  attr_accessible :name, :user_id, :version, :state
  
  validates :name, :user_id, presence: true
  
  attr_accessor :client_id
  
  belongs_to :user
  
  has_many :favorites
  
  def as_json(options)
    {
      id: self.id,
      name: self.name || "",
      user_email: self.user.try(:email),
      version: self.version,
      state: self.state,
      client_id: self.client_id
    }
  end
  
  # after_save :add_version
  # def add_version
    # self.class.increment_counter(:version, self.id) if self.visible == true
  # end
  
end
