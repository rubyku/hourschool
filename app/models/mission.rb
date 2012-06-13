class Mission < ActiveRecord::Base
  belongs_to :account
  belongs_to :city

  has_many :topics
  has_many :courses

  has_attached_file :photo, :styles => { :thumbnail => "75x75#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/:style/:id/:filename"

end
