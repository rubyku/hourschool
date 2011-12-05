class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  validates_presence_of :name, :location
  # Setup accessible (or protected) attributes for your model
  #validate :supported_location, :location_format
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :fb_token
  attr_accessible :zipcode, :zip, :bio, :referral, :facebook, :twitter, :web

  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :croles, :dependent => :destroy
  has_many :courses, :through => :croles

  has_many :payments

  has_attached_file :photo, :styles => { :small => "190x120#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "user/:style/:id/:filename"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  attr_accessible :photo


  acts_as_voter


  after_save :update_location_database
  after_create :send_reg_email

  def zipcode
    self.zip
  end

  def zipcode=(zip)
    if !zip.nil? && !zip.blank?
      loc = Geokit::Geocoders::GoogleGeocoder.geocode "#{zip}"
      if !loc.city.nil? && !loc.state.nil?
        self.location = loc.city + ", " + loc.state
        self.zip = zip
      end
    end
    nil
  end


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
        # SUPPORTED_CITIES.each do |sc|
        #           #city within 30 miles of supported
        #           if City.distance_between("#{sc}", "#{data["location"]["name"]}") <= 30
        #              return User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :name => data["name"],
        #                             :location => sc, :fb_token => access_token["credentials"]["token"])
        #           end
        #         end
        #        return "ec-not-supported"
        if data["location"]["name"].nil?
          return nil
        else
          return User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :name => data["name"],
                                     :location => data["location"]["name"], :fb_token => access_token["credentials"]["token"])
        end
      end
    end
  end

  def hearts
    sum = 0
    self.courses.each do |s|
      sum += s.votes_for
    end
    sum
  end

  def recent_classes_as_student
    date = Date.today
    all_student_roles = self.croles.where(:role => "student").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    classes = (all_upcoming_classes & all_student_roles)
    return classes
  end

  def recent_classes_as_teacher
     date = Date.today
     all_teacher_roles = self.croles.where(:role => "teacher").map(&:course)
     all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
     classes = (all_upcoming_classes & all_teacher_roles)
     return classes
   end

  def past_classes_as_student
    all_student_roles = self.croles.where(:role => "student").map(&:course)
    all_past_classes = self.courses.where(['date < ?', DateTime.now])
    classes = (all_past_classes & all_student_roles)
    classes = (all_past_classes & all_student_roles)
    return classes
  end

  def past_classes_as_teacher
     all_teacher_roles = self.croles.where(:role => "teacher").map(&:course)
     all_past_classes = self.courses.where(['date < ?', DateTime.now])
     classes = (all_past_classes & all_teacher_roles)
     classes = (all_past_classes & all_teacher_roles)
     return classes
   end

  def suggestions
    suggestions = Csuggestion.where(:requested_by => self.id)
    return suggestions
  end

  def pending
    if self.is_admin?
      #if user is admin return all pending in the dashbboard
      Course.where(:status => "proposal")
    else
      pending = self.courses.where(:status => "proposal")
      return pending
    end
  end

  def approved_classes
      approved = self.courses.where(:status => "approved")
      return approved
  end

  def student_for
    all_student_roles = self.croles.where(:role => "student").map(&:course)
    all_past_classes = self.courses.where(['date < ?', DateTime.now])
    (all_past_classes & all_student_roles).count

  end

  def teacher_for
      all_teacher_roles = self.croles.where(:role => "teacher").map(&:course)
      all_past_classes = self.courses.where(['date < ?', DateTime.now])
      (all_past_classes & all_teacher_roles).count
  end

  def student_for_up
    date = Date.today
    all_student_roles = self.croles.where(:role => "student").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_student_roles).count
  end

  def teacher_for_up
    date = Date.today
    all_teacher_roles = self.croles.where(:role => "teacher").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_teacher_roles).count
  end

  def is_teacher_for?(course)
    teaching_courses = self.croles.where(:role => 'teacher').collect{|c| c.course_id}
    return teaching_courses.include?(course.id)
  end

  def city
    nil
    location.split(',')[0].strip unless location.nil?
  end

  def state
    nil
    location.split(',')[1].strip unless location.nil?
  end

  def is_admin?
    #ideally should check the admin column
    email = self.email
    email == "saranyan13@gmail.com" || email == "alex@hourschool.com" || email == "ruby@hourschool.com" || email == "saranyan@hourschool.com"
  end

  private
  # def supported_location
  #     SUPPORTED_CITIES.each do |sc|
  #       #city within 30 miles of supported
  #       if City.distance_between("#{sc}", location) <= 30
  #          return
  #       end
  #     end
  #    errors.add(:location, "- Hourschool is not operating yet in your location")
  #   end

  def location_format
    errors.add(:location, "- Should be City, State") unless location.include?(',') && location.split(',').size == 2
  end

  def update_location_database
    cities = City.where(:name => self.city, :state => self.state)
    if cities.first.nil?
      #add the city in our database. One user can trigger a city
      g = Geokit::Geocoders::GoogleGeocoder.geocode "#{self.zip}"
      City.create!(:name => self.city, :state => self.state, :lat => g.lat, :lng => g.lng)
    end

  end

  def send_reg_email
    UserMailer.send_registration_mail(self.email, self.name).deliver

  end




end
