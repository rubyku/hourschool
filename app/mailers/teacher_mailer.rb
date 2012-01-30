class TeacherMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def send_course_proposal_reminder(course)
    @course = course
    @teacher = course.teacher
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Your class, #{@course.title}, has been approved, but you have not made it live yet!")
  end

  def send_invite_friends_mail(course)
    @course = course
    @teacher = course.teacher
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Your class needs more students!")
  end

  def send_positive_confirmation(course)
    @course = course
    @teacher = course.teacher
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Reminder: You're teaching #{@course.title} tomorrow!")
  end

  def send_negative_confirmation(course)
    @course = course
    @teacher = course.teacher
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{@course.title} didn't get enough students")
  end

  def send_post_class_feedback(course)
    @course = course
    @teacher = course.teacher
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Let us know how class went!")
  end

end