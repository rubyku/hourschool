class Course < ActiveRecord::Base
  belongs_to :city
  
  has_many :croles, :dependent => :destroy
  has_many :users, :through => :croles
  
  attr_accessible :title,:description, :price, :seats, :date, :time, :place, :minimum
   
  validates_presence_of :title,:description, :price, :seats, :date, :time, :place, :minimum
  
  acts_as_taggable_on :categories
  
  has_attached_file :photo, :styles => { :small => "150x150>" },
                      :url => "/images/courses/:id/:style/:basename.:extension"

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
