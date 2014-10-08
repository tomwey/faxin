class Folder < ActiveRecord::Base
  attr_accessible :name, :user_id, :version, :state
  
  validates :name, :user_id, presence: true
  
  belongs_to :user
  
  has_many :favorites
  
  def as_json(options)
    {
      id: self.id,
      name: self.name || "",
      user_email: self.user.try(:email),
      version: self.version,
      state: self.state
    }
  end
  
  after_save :add_version
  def add_version
    self.class.increment_counter(:version, self.id) if self.visible == true
  end
  
end
