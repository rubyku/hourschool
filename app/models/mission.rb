class Mission < ActiveRecord::Base
  belongs_to :account
  belongs_to :city

  has_many :topics
  has_many :comments, :order => "created_at", :dependent => :destroy
  has_many :courses
  has_many :invites, :as => :invitable
  has_many :crewmanships
  has_many :users, :through => :crewmanships
  
  has_attached_file :photo, :styles => { :thumbnail => "75x75#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/:style/:id/:filename"


  def creator
    creators = crewmanships.where(:role => 'creator')
    if creators.any?
      creators.first.user
    else
      nil
    end
  end

end
