class Course < ActiveRecord::Base
  belongs_to :city

  has_many :roles, :dependent => :destroy
  has_many :users, :through => :roles

  has_many :payments

  attr_accessible :title,:description, :price, :max_seats, :date, :time_range, :place_name, :min_seats
  attr_accessible :status, :teaser, :experience, :coursetag, :address, :phone_number, :public
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
  validates_presence_of :title, :description, :price, :max_seats, :time_range, :place_name, :min_seats, :unless => :proposal?

  validate :default_validations, :message => "The fields cannot be empty"
  attr_accessible :terms_of_service

  acts_as_taggable_on :categories

  default_scope order(:date, :time)
  self.per_page = DEFAULT_PER_PAGE = 9

  has_attached_file :photo, :styles => { :small => "190x120#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/:style/:id/:filename",
                    :processors => [:cropper]


  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h  

  after_update :reprocess_photo, :if => :cropping?

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  attr_accessible :photo

  extend FriendlyId
  friendly_id :pretty_slug, :use => :history
  acts_as_voteable


  def days_left
    (date.to_date - Time.now.to_date).to_i
  end

  def pretty_slug
    if city.present?
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
    order('rand()')
  end

  def self.near(options = {})
    origin = options[:zip]
    radius = options[:radius]||options[:distance]||30
    cities = City.geo_scope(:origin=> origin, :conditions=>"distance < #{radius}")
    self.where(:city_id => cities.map(&:id))
  end


  def self.located_in(city)
    if city.downcase == "all"
      where("")
    else
      joins(:city).where("name like ?", city)
    end
  end

  def self.active
    where("DATE(date) BETWEEN DATE(?) AND DATE(?)", Time.now.end_of_day, 4.weeks.from_now)
  end

  def self.active_tags
    active.tag_counts_on(:categories).order(:name)
  end

  def teacher
    teachers = roles.where(:role => 'teacher')
    if teachers.any?
      teachers.first.user
    else
      nil
    end
  end

  def students
    students = roles.where(:role => 'student')
    if students.any?
      students.collect(&:user)
    else
      []
    end
  end

  def is_a_student?(user)
    students = roles.where(:role => 'student')
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
    self.max_seats - self.students.count
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

    def reprocess_photo
      photo.reprocess!
    end

   #validations
   def default_validations

     if self.status == "proposal"
       if self.title.blank? || self.teaser.blank? || self.experience.blank?
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



end
