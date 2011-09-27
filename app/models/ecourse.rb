class Ecourse < ActiveRecord::Base
  belongs_to :enterprise
  has_many :members, :through => :eroles, :dependent => :destroy
  has_many :eroles, :dependent => :destroy
  
  attr_accessible :title,:description, :price, :seats, :date, :time, :place, :minimum
  validates_presence_of :title,:description, :price, :seats, :date, :time, :place, :minimum
  
  acts_as_taggable_on :categories
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                      :url => "/images/courses/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  attr_accessible :photo
  has_friendly_id :title, :use_slug => true, :strip_non_ascii => true
  
end
