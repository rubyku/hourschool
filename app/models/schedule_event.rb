class ScheduleEvent < ActiveRecord::Base
  belongs_to :series

  validates :series_id, :presence => true

  def publish!
    Course.duplicate(self.course, :date => self.starts_at.to_date)
    self.update_attributes(:published => true)
  end

  def last_course
    series.last_course
  end
  alias :course :last_course

end
