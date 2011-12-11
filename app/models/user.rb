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

  has_many :roles, :dependent => :destroy
  has_many :courses, :through => :roles

  has_many :payments

  has_attached_file :photo, :styles => { :small => "190x120#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "user/:style/:id/:filename"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  attr_accessible :photo


  acts_as_voter

  before_save :update_time_zone
  after_save :update_location_database
  after_create :send_reg_email

  def self.rk; where(:email => 'ruby@hourschool.com').first; end
  def self.rs; where(:email => 'richard.schneeman@gmail.com').first; end

  def self.random
    order('rand()')
  end

  def update_time_zone
    if time_zone.blank? && zip.present? && zip_changed?
      self.time_zone = Timezone::Zone.new(:latlon => [lat, lng]).zone
    end
  end

  def lat
    return nil if zip.blank?
    @geocode ||= Geokit::Geocoders::GoogleGeocoder.geocode(zip)
    @geocode.lat
  end

  def lng
    return nil if zip.blank?
    @geocode ||= Geokit::Geocoders::GoogleGeocoder.geocode(zip)
    @geocode.lng
  end


  def zipcode
    self.zip
  end

  def zipcode=(zip)
    return nil if zip.blank?
    @geocode ||= Geokit::Geocoders::GoogleGeocoder.geocode(zip)
    if !loc.city.nil? && !loc.state.nil?
      self.location = loc.city + ", " + loc.state
      self.zip = zip
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
    all_student_roles = self.roles.where(:role => "student").map(&:course)
    all_upcoming_classes = self.courses.where(['date >= ?', Time.now])
    classes = (all_upcoming_classes & all_student_roles)
    return classes.sort_by {|course| course.date }
  end

  def recent_classes_as_teacher
     date = Date.today
     all_teacher_roles = self.roles.where(:role => "teacher").map(&:course)
     all_upcoming_classes = self.courses.where(['date >= ?', Time.now])
     classes = (all_upcoming_classes & all_teacher_roles)
     return classes.sort_by {|course| course.date }
   end

  def past_classes_as_student
    all_student_roles = self.roles.where(:role => "student").map(&:course)
    all_past_classes = self.courses.where(['date < ?', DateTime.now])
    classes = (all_past_classes & all_student_roles)
    return classes.sort_by {|course| course.date }
  end

  def past_classes_as_teacher
     all_teacher_roles = self.roles.where(:role => "teacher").map(&:course)
     all_past_classes = self.courses.where(['date < ?', DateTime.now])
     classes = (all_past_classes & all_teacher_roles)
     return classes.sort_by {|course| course.date }
   end

  def suggestions
    suggestions = Suggestion.where(:requested_by => self.id)
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
    all_student_roles = self.roles.where(:role => "student").map(&:course)
    all_past_classes = self.courses.where(['date < ?', DateTime.now])
    (all_past_classes & all_student_roles).count

  end

  def teacher_for
      all_teacher_roles = self.roles.where(:role => "teacher").map(&:course)
      all_past_classes = self.courses.where(['date < ?', DateTime.now])
      (all_past_classes & all_teacher_roles).count
  end

  def student_for_up
    date = Date.today
    all_student_roles = self.roles.where(:role => "student").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_student_roles).count
  end

  def teacher_for_up
    date = Date.today
    all_teacher_roles = self.roles.where(:role => "teacher").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_teacher_roles).count
  end

  def is_teacher_for?(course)
    teaching_courses = self.roles.where(:role => 'teacher').collect{|c| c.course_id}
    return teaching_courses.include?(course.id)
  end

  def city
    nil
    location.split(',')[0].strip unless location.nil?
  end

  def state
    loc = location.split(',')[1]
    loc.strip unless loc.blank?
  end

  def is_admin?
    #ideally should check the admin column
    email = self.email
    email == "saranyan13@gmail.com" || email == "alex@hourschool.com" || email == "ruby@hourschool.com" || email == "saranyan@hourschool.com"
  end


  # ================================
  # User Conversion Code
  # Used to convert legacy passwords
  # Can remove in a few months
  # December, 5 2011
  # ================================

  def has_legacy_password?
    legacy_password_hash.present? && legacy_password_salt.present?
  end

  def valid_legacy_password?(password)
    calculated_hash =  BCrypt::Engine.hash_secret(password, legacy_password_salt)
    Devise.secure_compare(legacy_password_hash, calculated_hash)
  end

  def convert_legacy_password!(password)
    return false if !has_legacy_password? || !valid_legacy_password?(password)
    self.password = password
    if encrypted_password.present?
      self.legacy_password_hash = nil
      self.legacy_password_salt = nil
      self.save
    end
  end


  def valid_password?(password)
    return false if encrypted_password.blank?
    bcrypt   = ::BCrypt::Password.new(self.encrypted_password)
    password = ::BCrypt::Engine.hash_secret("#{password}#{self.class.pepper}", bcrypt.salt)
    Devise.secure_compare(password, self.encrypted_password)
  end

  # ================================

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
    return true unless self.zip_changed?
    cities = City.where(:name => self.city, :state => self.state)
    if cities.blank?
      g = Geokit::Geocoders::GoogleGeocoder.geocode "#{self.zip}"
      City.create(:name => self.city, :state => self.state, :lat => g.lat, :lng => g.lng)
    end
  end

  def send_reg_email
    UserMailer.send_registration_mail(self.email, self.name).deliver

  end




end
