class ConvertCoursesDateToDate < ActiveRecord::Migration
  def self.up
    add_column :courses, :start_date, :date
    Course.find_each do |course|
      Time.zone = course.teacher.time_zone
      course.update_attribute(:start_date, course.date.to_date) unless course.date.nil?
    end
    remove_column :courses, :date
    rename_column :courses, :start_date, :date
  end

  def self.down
  end
end
