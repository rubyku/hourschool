class RenameCourseFields < ActiveRecord::Migration

  def self.course_fields_before_to_after
    {
     :minimum   => :min_seats, 
     :about     => :teaser, 
     :phonenum  => :phone_number, 
     :seats     => :max_seats, 
     :place     => :place_name
     }
  end
  
  def self.up
    course_fields_before_to_after.each do |from, to|
      rename_column :courses, from, to
      # rename_column :table, :old_column, :new_column
    end
    change_column :courses, :date, :datetime
  end

  def self.down
    course_fields_before_to_after.each do |from, to|
      rename_column :courses, to, from
    end
    change_column :courses, :date, :date
  end
end
