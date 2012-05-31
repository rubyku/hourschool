class ConvertExisitingCourseDateAndTimeStringToDatetime < ActiveRecord::Migration
  def up
    fixed = []
    skipped = []
    blank = []
    Course.all.each do |course|
      if course.time_range.blank?
        blank << course.id

      elsif course.time_range.downcase.include?('-') && (course.time_range.downcase.include?('am') || course.time_range.downcase.include?('pm') || course.time_range.downcase.include?('p'))
        time_range = course.time_range.downcase
        start_time = course.time_range.split('-').first
        end_time = course.time_range.split('-').last
        
        if start_time.include?('am') || start_time.include?('pm') || start_time.include?('p')  
          course.starts_at = "#{course.date} #{start_time}".to_time
        else
          ampm = end_time.include?('am') ? 'am' : 'pm'
          course.starts_at = "#{course.date} #{start_time} #{ampm}".to_time
        end

        if end_time.include?('am') || end_time.include?('pm') || end_time.include?('p')
          course.ends_at = "#{course.date} #{start_time}".to_time
          course.save!
          puts "course:#{course.id} #{course.date} #{course.time_range} ====> #{course.starts_at} #{course.ends_at}"
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
