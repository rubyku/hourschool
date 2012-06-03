class ConvertExisitingCourseDateAndTimeStringToDatetime < ActiveRecord::Migration
  def up
    fixed = []
    skipped = []
    blank = []
    Course.all.each do |course|
      # puts "Course:#{course.id}"
      if course.time_range.blank? || course.city.nil? || course.city.time_zone.blank?
        blank << course.id

      elsif course.time_range.downcase.include?('-') && (course.time_range.downcase.include?('am') || course.time_range.downcase.include?('pm') || course.time_range.downcase.include?('p'))
        Time.zone = course.city.time_zone
        time_range = course.time_range.downcase
        start_time = course.time_range.split('-').first
        end_time = course.time_range.split('-').last
        
        if start_time.include?('am') || start_time.include?('pm') || start_time.include?('p')  
          course.starts_at = Time.zone.parse "#{course.date} #{start_time}"
        else
          ampm = end_time.include?('am') ? 'am' : 'pm'
          course.starts_at = Time.zone.parse "#{course.date} #{start_time} #{ampm}"
        end

        if end_time.include?('am') || end_time.include?('pm') || end_time.include?('p')
          course.ends_at = Time.zone.parse "#{course.date} #{end_time}"
          course.save!
          puts "course:#{course.id} #{course.date} #{course.time_range} ====> #{course.starts_at.strftime('%D %r')} -> #{course.ends_at.strftime('%D %r')}"
          fixed << course.id
        else
         skipped << course.id
        end

      else
        skipped << course.id
      end
    end
    
    puts "Fixed #{fixed.length} courses: #{fixed.inspect}"
    puts "----"
    puts "Skipped #{skipped.length} courses: #{skipped.inspect}"
    puts "----"
    puts "Blank #{blank.length} courses: #{blank.inspect}"
  end

  def down
  end
end
