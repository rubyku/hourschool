class ScheduleEvent < ActiveRecord::Base
  belongs_to :series

  validates :series_id, :presence => true

  def last_course
    series.last_course
  end
  alias :course :last_course

end
