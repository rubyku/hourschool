class Course < ActiveRecord::Base
  belongs_to :city
  
  has_many :croles, :dependent => :destroy
  has_many :users, :through => :croles
  
  has_many :payments
  
  attr_accessible :title,:description, :price, :seats, :date, :time_range, :place, :minimum
  attr_accessible :status, :about, :experience, :coursetag, :address, :phonenum, :public
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
  #validates_presence_of :title,:description, :price, :seats, :date, :time_range, :place, :minimum
  validates_presence_of :title,:description, :price, :seats, :time_range, :place, :minimum, :unless => :proposal? 
  
  validate :default_validations, :message => "The fields cannot be empty"
  validates :terms_of_service, :acceptance => true
  attr_accessible :terms_of_service
  
  acts_as_taggable_on :categories
  
  
  has_attached_file :photo, :styles => { :small => "190x120#", :large => "570x360>" },
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :path => "/:style/:id/:filename",
                    :processors => [:cropper]
                           
                           
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #before_update :reprocess_photo, :if => :cropping?
  after_update :reprocess_photo, :if => :cropping?
  
  #:url => "/images/courses/:id/:style/:basename.:extension"
  #:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  #:s3_credentials => S3_CREDENTIALS,
  #:processors => [:cropper]
  #:path => "/:style/:id/:filename",
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  attr_accessible :photo
  has_friendly_id :title, :use_slug => true, :strip_non_ascii => true
  acts_as_voteable
  
  
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
   
   
   def cropping?
       p "cropping? = #{!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?}"
       p "crop_x = #{crop_x}, crop_y = #{crop_y}, crop_w = #{crop_w}, crop_h = #{crop_h}"
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
      p "hello world"
      photo.reprocess!
    end
   
   #validations
   def default_validations
    
     if self.status == "proposal"
       if self.title.blank? || self.about.blank? || self.experience.blank?
         #errors.add(:title, "Title cannot be blank!") unless !self.title.blank?
         #errors.add(:about, "About field cannot be blank!") unless !self.about.blank?
         #errors.add(:experience, "Experience field cannot be blank!") unless !self.experience.blank?
         errors[:base] << "All the fields are required!"
       
       end
     end
   end
   
   def proposal?
     self.status == "proposal" || self.status.nil?
   end
   
   
  
end
