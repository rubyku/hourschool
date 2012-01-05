class Track < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  # probably would make sense to move this
  # to a real ActiveRecord relationship
  # but for now everything is contained here
  serialize :course_ids
  def courses
    Course.find(course_ids)
  end
end
