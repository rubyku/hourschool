class Series < ActiveRecord::Base
  has_many :courses, :dependent => :destroy
  
  
  extend FriendlyId
  friendly_id :name, :use => :slugged
  
  def to_params
    slug
  end
  
  def count_students(student_count)
    sum = 0
    if student_count.nil?
      self.courses.each do |c|
        sum += c.students.size
      end
    else
      sum = student_count
      sum += self.courses.last.students.size
    end
    sum
  end

end
