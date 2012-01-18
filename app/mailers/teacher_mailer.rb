class TeacherMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def send_course_proposal_reminder
    @course = course
    @teacher = course.teacher
    mail(:to => @teacher.email, :subject => "Your class, #{@course.title}, has been approved, but you have not made it live yet!")
  end
  
  def send_teacher_resources
    @course = course
    @teacher = course.teacher
    mail(:to => @teacher.email, :subject => "Here are some resources to help you teach #{@course.title} next week!")
  end
  
  def send_one_day_reminder(course)
    @course = course
    @teacher = course.teacher
    mail(:to => @teacher.email, :subject => "Reminder: You're teaching #{@course.title} tomorrow!")
  end
  
  def send_post_class_feedback(course)
    @course = course
    @teacher = course.teacher
    mail(:to => @teacher.email, :subject => "Thanks for using Hourschool! We appreciate your feedback!")      
  end

end