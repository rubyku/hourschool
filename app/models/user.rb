class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable
  devise :omniauthable

  attr_accessor :dont_send_reg_email

  validates_presence_of :name
  # Setup accessible (or protected) attributes for your model
  # validate :supported_location, :location_format

  include MethodCacheable
  extend FriendlyId
  friendly_id :name, :use => :slugged


  serialize :preferences, Hash

  belongs_to :city

  has_many :topics

  has_many :pre_missions_signups

  has_many :memberships
  has_many :accounts, :through => :memberships


  has_many :extra_tickets, :class_name => "Role", :foreign_key => :invite_user_id
  has_many :extra_ticket_users, :through => :extra_tickets, :source => "user"


  has_many :roles,   :dependent => :destroy
  has_many :courses, :through => :roles
  # has_many :courses_taught,   :through => :roles, :conditions => ["roles.name = (?) and course.status = 'live'", "teacher"], :source => :course
  has_many :courses_taught,   :through => :roles, :conditions => {:roles => {:name => "teacher"}, :courses => {:status => 'live'}}, :source => :course
  has_many :courses_approved, :through => :roles, :conditions => ["roles.name = (?) and course.status = 'approved'", "teacher"], :source => :course
  has_many :courses_attended, :through => :roles, :conditions => ["roles.name = (?)", "student"], :source => :course

  has_many :series, :through => :courses_taught

  has_many :payments
  has_many :comments, :dependent => :destroy

  has_many :followers, :through => :followings, :foreign_key => 'follower_id', :dependent => :destroy
  has_many :followed,  :through => :followings, :foreign_key => 'followed_id', :dependent => :destroy

  has_many :crewmanships,   :dependent => :destroy
  has_many :missions, :through => :crewmanships


  has_many :subscription_charges

  # User.last.sent_invites
  has_many :sent_invites, :foreign_key => :inviter_id, :class_name => :Invite

  has_attached_file :photo, :styles => {:small       => ["190x120",  :jpg],
                                        :large       => ["570x360>", :jpg],
                                        :thumb_large => ["125x125#", :jpg],
                                        :thumb_75    => ["75x75#", :jpg],
                                        :thumb_small => ["50x50#",   :jpg],
                                        :thumb_35    => ["35x35#",   :jpg],
                                        :thumb_25    => ["25x25#",   :jpg]
                                        },
                            :storage => :s3,
                            :s3_credentials => "#{Rails.root}/config/s3.yml",
                            :path => "user/:style/:id/:filename"

  validates_attachment_size :photo, :less_than => 5.megabytes


  acts_as_voter

  before_save  :update_time_zone
  before_save  :update_user_location
  after_save   :update_location_database
  after_create :send_reg_email, :unless => Proc.new {|u| u.dont_send_reg_email}


  accepts_nested_attributes_for :memberships



  include User::Omniauth
  include User::Facebook
  include User::FollowingMethods

  def self.create_invite_user
    user = User.new(:status => "invitee", :email => "tmp#{Time.now.to_f}@example.com", :invite_token => SecureRandom.hex(16))
    user.dont_send_reg_email = true
    user.save(:validate => false)
    user
  end

  def unsubscribed?(key)
    !wants?(key)
  end

  def subdomain
    return "" if memberships.blank?
    self.memberships.last.account.subdomain
  end

  def wants?(key)
    return true  if preferences.blank?
    preferences[key].present?
  end

  def wants_newsletter?
    wants?('mission_news')
  end

  def active?
    status == "active"
  end

  # for pretty links
  def to_params
    slug
  end

  def self.me_or_find(id, current_user)
    user_id = id.try(:to_s)
    if user_id.blank? || user_id == 'me' || user_id == 'current'
      current_user
    else
      User.find(user_id)
    end
  end

  def full_state
    StateAbreviations[city.try(:state).try(:upcase)]
  end

  def self.ap; where(:email => 'alex@hourschool.com').first; end
  def self.rk; where(:email => 'ruby@hourschool.com').first; end
  def self.rs; where(:email => 'richard.schneeman@gmail.com').first; end

  def self.random
    order('random()')
  end

  def update_time_zone
    if time_zone.blank? && zip.present? && zip_changed?
      self.time_zone = Timezone::Zone.new(:latlon => [lat, lng]).zone
    end
  end

  def taught?(course)
    course.teacher == self
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
    self.zip = zip
  end

  def hearts
    sum = 0
    self.courses.each do |s|
      sum += s.votes_for
    end
    sum
  end

  def suggestions(current_account=nil)
    suggestions = Suggestion.where(:requested_by => self.id)
    suggestions = suggestions.where(:account_id => current_account.id) if current_account
    return suggestions
  end

  def pending(current_account=nil)
    if self.admin?
      #if user is admin return all pending in the dashbboard
      Course.where(:status => "proposal")
    else
      pending = self.courses.where(:status => "proposal")
      pending = pending.where(:account_id => current_account.id) if current_account
      return pending
    end
  end

  def approved_classes(current_account=nil)
      approved = self.courses.where(:status => "approved")
      approved = approved.where(:account_id => current_account.id) if current_account
      return approved
  end

  def student_for
    all_student_roles = self.roles.where(:name => "student").map(&:course)
    all_past_classes = self.courses.where(['date < ?', DateTime.zone.now])
    (all_past_classes & all_student_roles).count

  end

  def teacher_for
      all_teacher_roles = self.roles.where(:name => "teacher").map(&:course)
      all_past_classes = self.courses.where(['date < ?', DateTime.zone.now])
      (all_past_classes & all_teacher_roles).count
  end

  def student_for_up
    date = Date.today
    all_student_roles = self.roles.where(:name => "student").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_student_roles).count
  end

  def teacher_for_up
    date = Date.today
    all_teacher_roles = self.roles.where(:name => "teacher").map(&:course)
    all_upcoming_classes = self.courses.where('(date BETWEEN ? AND ?) ', date, date.advance(:weeks => 4))
    (all_upcoming_classes & all_teacher_roles).count
  end

  def is_teacher_for?(course)
    teaching_courses = self.roles.where(:name => 'teacher').collect{|c| c.course_id}
    return teaching_courses.include?(course.id)
  end

  def state
    loc = location || ","
    loc = loc.split(',')[1]
    loc.strip unless loc.blank?
  end

  def twitter_url
    "http://twitter.com/#{self.twitter_id}"
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

  def send_reg_email
    membership = self.memberships.order('created_at desc').first
    if membership
      current_account = membership.account
    else
      current_account = nil
    end
    UserMailer.user_registration(self.email, self.name, current_account).deliver

    if current_account == Account.where(:id => 9).first
      @admins = Membership.where(:account_id => current_account, :admin => true)
      @admins.each do |admin|
        UserMailer.account_new_member(admin.user, current_account, self).deliver
      end
    end
  end

  #after user has put in payment info, a stripe customer is created
  def create_stripe_customer(params)
    stripe_customer = Stripe::Customer.create(params)
    if stripe_customer
      update_attribute(:stripe_customer_id, stripe_customer.id)
    else
      false
    end
  end

  def member_of_mission_for_course?(course)
    self.crewmanships.where(:mission_id => course.mission.id).present?
  end

  def not_member_of_mission_for_course?(course)
    !member_of_mission_for_course?(course)
  end


  #setting variable for stripe customer (to charge..etc)
  def stripe_customer
    if stripe_customer_id.present?
      @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
    else
      nil
    end
  end

  #balance based on # of crewmanships a user has
  def balance
    crewmanships.collect(&:price).map {|p| p[:amount] }.inject{|sum,x| sum + x }
  end

  #this creates a stripe charge
  def charge_for_active_crewmanships
    begin
      amount   = (balance * 100).to_i
      missions = crewmanships.where('status in (?)', %w(active past_due)).collect(&:mission)
      charge   = make_charge_with_stripe(amount, missions)
      if charge
        crewmanships.where(:status => %w(trial_active trial_expired past_due)).collect {|c| c.update_attribute(:status, 'active')}
        # email a receipt
        # mention in the receipt if their charge was $0
        true
      else
        false
      end
    rescue => e
      if crewmanships.where(:status => 'past_due').any?
        crewmanships.where(:status => 'past_due').collect {|c| c.update_attribute(:status, 'abandoned')}
        # send an email tell them their account is abandoned
      else
        crewmanships.where(:status => 'active').collect {|c| c.update_attribute(:status, 'past_due')}
        # logger.info "[Crewmanship: #{crewmanships.where(:status => 'active').collect(&:id).inspect}] active => past_due"
        # send an email tell them their payment failed
      end
      false
    end
  end

  def make_charge_with_stripe(amount, missions)
    if amount == 0
      subscription_charges.create(
        :amount => 0,
        :paid => true,
        :description => "Charge for #{Time.zone.now.strftime('%B %D')}. Missions: #{missions.collect(&:title).to_sentence}"
      )
      true
    else
      charge = Stripe::Charge.create(
        :amount => amount,
        :currency => "usd",
        :customer => stripe_customer.id,
        :description => "Charge for #{Time.zone.now.strftime('%B %D')}. Missions: #{missions.collect(&:title).to_sentence}"
      )
      subscription_charges.create(
        :params => charge.inspect,
        :amount => charge.amount,
        :paid => charge.paid,
        :stripe_card_fingerprint => charge.card.fingerprint,
        :stripe_customer_id => charge.customer,
        :stripe_id => charge.id,
        :card_last_4 => charge.card.last4,
        :card_type => charge.card.type,
        :description => charge.description
      )
      charge.paid
    end
  end

  #this gets run by the daily rake task which charge customers on their billing date
  def self.monthly_charge
    User.where(:billing_day_of_month => Time.zone.now.date).each do |user|
      user.charge_for_active_crewmanships
    end
  end

  def last_months_billing_date
    one = 1.month.ago
    Date.parse("#{one.year}-#{one.month}-#{billing_day_of_month}")
  end

  def this_months_billing_date
    one = Time.zone.now
    Date.parse("#{one.year}-#{one.month}-#{billing_day_of_month}")
  end

  def taught_class_between_last_billing_cycle?(mission)
    courses_taught.
    where('starts_at >= ?', last_months_billing_date.beginning_of_day).
    where('starts_at <= ?', (this_months_billing_date - 1.day).end_of_day).
    where(:mission_id => mission.id).
    any?
  end

  # ================================
  # End user conversion Code
  # ================================
  private
  def update_user_location
    return true if zip.blank?
    return true unless self.zip_changed?
    @geocode ||= Geokit::Geocoders::GoogleGeocoder.geocode(zip)
    if !@geocode.city.nil? && !@geocode.state.nil?
      self.location = [@geocode.city, @geocode.state].join(", ")
    end
  end

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
end
