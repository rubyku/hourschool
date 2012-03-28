class Series < ActiveRecord::Base
  has_many    :courses, :dependent => :destroy

  before_save :update_last_course_id, :default_name

  has_many    :schedule_events
  include Series::EventSchedule

  extend FriendlyId
  friendly_id :name, :use => :history

  validates :name, :presence => true, :uniqueness => true

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

  def last_course
    Course.where(:id => last_course_id).first
  end


  private

  def should_generate_new_friendly_id?
    slug.blank? && name.present?
  end

  def update_last_course_id
    last_id = courses.order(:created_at).last.try(:id)
    self.last_course_id = last_id if last_id.present?
    true
  end

  def default_name
    return true if self.name.present?
    self.name = last_course.name
    true
  end

end
