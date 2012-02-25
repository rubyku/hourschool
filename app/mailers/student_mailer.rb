class StudentMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def send_invite_friends_mail(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "The class you signed up for is 3 days away and needs more students!")
  end

  def send_positive_confirmation(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "The class you signed up for is today!")
  end

  def send_negative_confirmation(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "The class you signed up for has been canceled")
  end

  def send_post_class_feedback(student, course)
    @student = student
    @course  = course
    @teacher = course.teacher
    Time.zone = @student.time_zone
    mail(:to => @student.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Let us know how class went!")
  end

  def course_is_canceled(student, course, msg = '')
    @student         = student
    @course          = course
    @teacher         = course.teacher
    @teacher_message = msg
    Time.zone = @student.time_zone
    mail(:to => @student.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Your course was canceled")
  end

  class Preview < MailView
    # Pull data from existing fixtures
    def course_is_canceled
      course   = Course.live.last
      student  = User.last
      msg      = 'sorry i got the flu'
      StudentMailer.course_is_canceled(student, course, msg)
    end
  end

end