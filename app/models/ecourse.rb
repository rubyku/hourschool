class Ecourse < ActiveRecord::Base
  belongs_to :enterprise
  has_many :members, :through => :eroles, :dependent => :destroy
  has_many :eroles, :dependent => :destroy

  attr_accessible :title,:description, :price, :seats, :date, :time, :place, :minimum
  validates_presence_of :title,:description, :price, :seats, :date, :time, :place, :minimum

  acts_as_taggable_on :categories

  has_attached_file :photo, :styles => { :small => "150x150>" },
                      :url => "/images/courses/:id/:style/:basename.:extension"

  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  attr_accessible :photo

  def teacher
     teachers = eroles.where(:role => 'teacher')
     if teachers.any?
       teachers.first.member
     else
       nil
     end
   end

   def students
     students = eroles.where(:role => 'student')
     if students.any?
       students.collect(&:member)
     else
       []
     end
   end

   def is_a_student?(member)
      students = eroles.where(:role => 'student')
      if students.any?
        return students.collect(&:member).include?(member)
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
