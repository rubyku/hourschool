class Course < ActiveRecord::Base
  belongs_to :city
  belongs_to :series
  belongs_to :account
  belongs_to :mission

  has_and_belongs_to_many :topics

  has_many :roles, :dependent => :destroy
  has_many :users, :through => :roles
  alias_attribute :name, :title

  has_many :comments, :order => "created_at", :dependent => :destroy
  has_many :payments

  has_many :invites, :as => :invitable

  validates_presence_of :title, :description, :photo, :starts_at, :ends_at, :price, :place_name, :min_seats, :city_id

  validate :default_validations, :message => "The fields cannot be empty"
  validate :not_past_date, :on => :create

  acts_as_taggable_on :categories

  self.per_page = DEFAULT_PER_PAGE = 9

  has_attached_file :photo, :styles => { :small => "190x120#",
                                         :thumb_258 => "258x138#",
                                         :thumb_300 => "300x252#",
                                         :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/:style/:id/:filename",
                    :processors => [:cropper]


  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  after_update :reprocess_photo, :if => :cropping?
  after_save   :notify_followers


  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  extend FriendlyId
  friendly_id :pretty_slug, :use => :history
  acts_as_voteable

  include Course::Searchable

  def self.in_account(account)
    where('account_id in (?)', account ? [account.id] : [0,nil])
  end

  def self.community
    where('account_id in (?) or account_id is null', Account.public_ids).where(:seed => false)
  end

  def cancel!
    update_attributes :happening => false, :status => 'canceled'
  end

  def notify_cancel!(msg = '')
    return false if inactive?
    students.each do |student|
      StudentMailer.delay.course_is_canceled(student, self, msg)
    end
  end

  # for pretty links
  def to_params
    slug
  end

  def lat
    city.try(:lat)
  end

  def lng
    city.try(:lng)
  end

  def free?
    self.price == 0
  end

  def draft?
    !self.status == "live"
  end

  def days_left
    (date - Time.current.to_date).to_i
  end

  def pretty_slug
    if seed?
      "#{title}-in-#{city.name_state}-#{account_id}"
    elsif city.present?
      "#{title}-in-#{city.name_state}"
    else
      "#{title}"
    end
  end

  def self.exclude(resource)
    if resource.present?
      where("id not in (?)", resource.map(&:id))
    else
      where("")
    end
  end


  def self.random
    order('random()')
  end


  def self.near(options = {})
    origin = options[:zip]
    radius = options[:radius]||options[:distance]||30
    cities = City.geo_scope(:origin=> origin, :conditions=>"distance < #{radius}", :order => 'distance')
    self.where(:city_id => cities.map(&:id))
  end


  def self.located_in(city)
    if city.downcase == "all"
      where("")
    else
      joins(:city).where("name like ? ", "%#{city}%")
    end
  end

  def self.live
    where(:status => 'live')
  end

  def self.active
    live.where('starts_at <= ?', 1.year.from_now.to_date).where('starts_at >= ?', Date.today)
  end

  def self.past
    where(:status => 'live').where("DATE(starts_at) < (?)", Time.current)
  end

  def inactive?
    !active?
  end

  def sold_out?
    self.max_seats.present? && self.students.size >= self.max_seats
  end
  alias :soldout? :sold_out?
  alias :full?    :sold_out?

  def active?
    return false if starts_at.blank?
    self.starts_at < 1.year.from_now.to_date && self.starts_at >= Date.today
  end

  def self.active_tags
    active.tag_counts_on(:categories).order(:name)
  end

  def teacher
    teachers = roles.where(:name => 'teacher')
    if teachers.any?
      teachers.first.user
    else
      nil
    end
  end

  def students
    students = roles.where(:name => 'student').where(:attending => true)
    if students.any?
      students.collect(&:user)
    else
      []
    end
  end

  def day_of_the_week_sym
    self.starts_at.strftime('%A').downcase.to_sym
  end

  def day_of_the_week_next_week
    Time.now.next_week(day_of_the_week_sym)
  end


  def day_in_weeks_from_now(weeks)
    day_of_the_week_next_week + weeks
  end


  def self.duplicate(course, options = {})
    duplicate = Course.new(course.attributes)
    duplicate.category_list = course.category_list
    duplicate.status        = "live"
    duplicate.starts_at     = options[:starts_at] || course.day_in_weeks_from_now(4.weeks)
    duplicate.ends_at       = duplicate.starts_at + 1.hour
    duplicate.photo         = course.photo if course.photo_file_name.present?
    duplicate.save!
    duplicate.roles.create(:user => course.teacher, :name => 'teacher')
    duplicate
  end

  # return true if user is blank (we don't know where they are)
  # or false if the cities don't match
  def near_user?(user)
     user.blank? || user.city.try(:name).nil? || self.city.name == user.city.try(:name)
  end

  def is_a_student?(user)
    students = roles.where(:name => 'student')
    if students.any?
      return students.collect(&:user).include?(user)
    else
      return false
    end
  end
  alias :has_student? :is_a_student?

  def canceled?
    status == 'canceled'
  end

  def is_not_a_student?(user)
    !is_a_student?(user)
  end
  alias :not_student? :is_not_a_student?

  def is_a_teacher?(user)
    self.teacher == user
  end
  alias :has_teacher? :is_a_teacher?

  def not_teacher?(user)
    !is_a_teacher?(user)
  end

  def seats_left
    self.max_seats - self.students.count
  end

   def future?
     starts_at - Date.today > 0
   end

   def today?
     starts_at - Date.today == 0
   end

   def past?
     starts_at - Date.today < 0
   end


   def cropping?
       !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
     end

   def photo_geometry(style = :original)
     @geometry ||= {}
     path = (photo.options[:storage] == :s3) ? photo.url(style) : photo.path(style)
     #@geometry[style] ||= Paperclip::Geometry.from_file(path)
    @geometry[style] ||= Paperclip::Geometry.from_file(photo.to_file(style))
   end

  private

  def notify_followers
    return true unless status_changed?
    return true if teacher.blank? || status != 'live'
    teacher.fetch_followers.each do |follower|
      # UserMailer.delay.followed_created_a_course(follower, teacher, self)
    end
    return true
  end

  # to find the current day you could call Course.on(Time.now) or Course.on(DateTime.parse("2012-10-14"))
  def self.on(date)
    where("starts_at > :beginning and starts_at < :ends", :beginning => date.beginning_of_day, :ends => date.end_of_day)
  end

  def reprocess_photo
    photo.reprocess!
  end

   #validations
  def default_validations
     if self.status == "proposal"
       if self.title.blank? || self.experience.blank?
         #errors.add(:title, "Title cannot be blank!") unless !self.title.blank?
         #errors.add(:teaser, "About field cannot be blank!") unless !self.teaser.blank?
         #errors.add(:experience, "Experience field cannot be blank!") unless !self.experience.blank?
         errors[:base] << "All the fields are required!"
       end
     end
   end

   def proposal?
     self.status == "proposal" || self.status.nil?
   end

   def not_past_date
     if self.starts_at < Date.today
       errors.add(:starts_at, 'is in the past')
     end
   end


end
