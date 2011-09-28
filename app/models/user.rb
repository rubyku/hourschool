class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  validates_presence_of :name, :location
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :fb_token
  has_friendly_id :name, :use_slug => true, :strip_non_ascii => true
  
  has_many :croles, :dependent => :destroy
  has_many :courses, :through => :croles
  
  
  acts_as_voter
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    p data
    #@graph = Koala::Facebook::GraphAPI.new(access_token["credentials"]["token"])
    #profile = @graph.get_object("me")
    #p profile
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      if data["location"].nil? 
        return nil
      else
        User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :name => data["name"], 
                      :location => data["location"]["name"], :fb_token => access_token["credentials"]["token"]) 
       
      end
    end
  end
  
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
