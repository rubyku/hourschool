class Mission < ActiveRecord::Base
  belongs_to :account
  belongs_to :city

  has_many :topics
  has_many :comments, :order => "created_at", :dependent => :destroy
  has_many :courses
  has_many :invites, :as => :invitable
  has_many :crewmanships
  has_many :users, :through => :crewmanships

  validate :live_missions_must_have_photo
  
  has_attached_file :photo, :styles => { :thumbnail => "75x75#", 
                                         :thumb_258 => "258x138#",
                                         :thumb_300 => "300x180",
                                         :preview => "570x360#", 
                                         :stats => "650x137#", 
                                         :banner => "959x349#" },
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

  def live_missions_must_have_photo
    if status == 'live' && photo_file_name.blank?
      errors.add(:photo, "must be added before mission can launch")
    end
  end

end
