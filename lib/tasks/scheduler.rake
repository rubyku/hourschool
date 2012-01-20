desc "Send scheduled emails"

task :send_class_proposal_emails => :environment do
  puts "Sending class proposal reminder emails..."
  pending_courses = Course.where("status = ?", "approved")
  pending_courses.each do |course|
    if (Date.today - course.updated_at.comparable_time.to_date) == 7
      TeacherMailer.send_course_proposal_reminder()
    end
  end
  puts "done"
end

task :send_student_emails => :environment do
  puts "Sending 72 hr student reminder emails..." 
  courses_in_3_days = Course.where("(date - :todays_date) = 3 AND status = :live", {:todays_date => Date.today, :live => "live"})
  courses_in_3_days.each do |course| 
    if students.size < course.min
      TeacherMailer.send_invite_friends_mail(course).deliver
      students = course.students
        students.each do |student|  
          StudentMailer.send_invite_friends_mail(student,course)
      end
    end
  end
  puts "done"
end

task :send_day_before_emails => :environment do
  puts "Sending day-before reminder emails..."
  courses_tomorrow = Course.tomorrows_courses
  courses_tomorrow.each do |course|
  if students.size >= course.min_seats
    TeacherMailer.send_positive_confirmation(course).deliver
    students.each do |student|
      StudentMailer.send_positive_confirmation(student, course).deliver
    end
  else
    students.each do |student|
      TeacherMailer.send_negative_confirmation(course).deliver
      StudentMailer.send_negative_confirmation(student, course).deliver
    end
  end
  end
  puts "done"
end

task :send_post_class_emails => :environment do
  puts "Sending post-class student feedback emails..."
  courses_yesterday = Course.where("(:todays_date - date) = 1 AND status = :live", {:todays_date => Date.today, :live => "live"})
  courses_yesterday.each do |course|
    students = course.students
    if students.size >= course.min
      TeacherMailer.send_post_class_feedback(course)
      students.each do |student|
        StudentMailer.send_post_class_feedback(student, course)
      end
    end
  end
  puts "done"
end


#schedule emails to nominees

task :send_nominee_reminder_emails => :environment do
  puts "Sending nominated teacher reminders..."
  # TBD: Use Roles - Need course/suggestion integration
  
  puts "done"
end
