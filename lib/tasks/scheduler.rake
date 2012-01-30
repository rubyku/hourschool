desc "Send scheduled emails"

task :send_class_proposal_reminder_emails => :environment do
  puts "Sending class proposal reminder emails..."
  pending_courses = Course.where("status = ? AND updated_at < ? AND updated_at > ?", "approved", 7.days.ago, 8.days.ago)
  pending_courses.each do |course|
      TeacherMailer.send_course_proposal_reminder(course).deliver
  end
  puts "done"
end

task :send_72hr_invite_friends_emails => :environment do
  puts "Sending 72 hr reminder emails..." 
  courses_in_3_days = Course.where("date = :todays_date AND status = :live", {:todays_date => 3.days.from_now, :live => "live"})
  courses_in_3_days.each do |course| 
    students = course.students
    if students.size < course.min_seats
      TeacherMailer.send_invite_friends_mail(course).deliver
      students.each do |student|  
        StudentMailer.send_invite_friends_mail(student,course).deliver
      end
    end
  end
  puts "done"
end

task :send_day_of_reminder_emails => :environment do
  puts "Sending day of reminder emails..."
  courses_today = Course.where("date = :todays_date AND status = :live", {:todays_date => Date.today, :live => "live"})
  courses_today.each do |course|
    students = course.students
    if students.size >= course.min_seats
      TeacherMailer.send_positive_confirmation(course).deliver
      students.each do |student|
        StudentMailer.send_positive_confirmation(student, course).deliver
      end
    else
      TeacherMailer.send_negative_confirmation(course).deliver
      # students.each do |student|
      #   StudentMailer.send_negative_confirmation(student, course).deliver
      # end
    end
  end
  puts "done"
end

task :send_post_class_emails => :environment do
  puts "Sending post-class feedback emails..."
  courses_yesterday = Course.where("(:yesterdays_date = date) AND status = :live", {:yesterdays_date => Date.yesterday, :live => "live"})
  courses_yesterday.each do |course|
    students = course.students
    if students.size >= course.min_seats
      TeacherMailer.send_post_class_feedback(course).deliver
      students.each do |student|
        StudentMailer.send_post_class_feedback(student, course).deliver
      end
    end
  end
  puts "done"
end

task :send_nominee_reminder_emails => :environment do
  puts "Sending nominated teacher reminders..."
  # TODO: Use Roles - Need course/suggestion integration
  
  puts "not implemented"
end
