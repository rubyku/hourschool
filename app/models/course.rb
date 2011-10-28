class Course < ActiveRecord::Base
  belongs_to :city
  
  has_many :croles, :dependent => :destroy
  has_many :users, :through => :croles
  
  has_many :payments
  
  attr_accessible :title,:description, :price, :seats, :date, :time_range, :place, :minimum
   
  validates_presence_of :title,:description, :price, :seats, :date, :time_range, :place, :minimum
  
  acts_as_taggable_on :categories
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                      :storage => :s3,
                          :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                           :path => "/:style/:id/:filename"
  #:url => "/images/courses/:id/:style/:basename.:extension"
  #:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #:s3_credentials => S3_CREDENTIALS,
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  attr_accessible :photo
  has_friendly_id :title, :use_slug => true, :strip_non_ascii => true
  
  
  def teacher
    teachers = croles.where(:role => 'teacher')
    if teachers.any?
      teachers.first.user
    else
      nil
    end
  end

  def students
    students = croles.where(:role => 'student')
    if students.any?
      students.collect(&:user)
    else
      []
    end
  end
  
  def is_a_student?(user)
    students = croles.where(:role => 'student')
    if students.any?
      return students.collect(&:user).include?(user)
    else
      return false
    end
    
  end
  
  def is_a_teacher?(user)
    self.teacher == user
  end
  
  def seats_left
    self.seats - self.students.count
  end
   
   def future?
     date - Date.today > 0
   end
   
   def today?
     date - Date.today == 0
   end
   
   def past?
     date - Date.today < 0
   end
  
end
