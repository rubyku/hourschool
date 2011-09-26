class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true
  
  has_many :croles, :dependent => :destroy
  has_many :courses, :through => :croles
  
  
  acts_as_voter
  
  
  def student_for
    return self.croles.where(:role => 'student').count
  end

  def teacher_for
    return self.croles.where(:role => 'teacher').count
  end
  
  def is_teacher_for?(course)
    teaching_courses = self.croles.where(:role => 'teacher').collect{|c| c.course_id}
    return teaching_courses.include?(course.id)
  end

end
