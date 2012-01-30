class StudentMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def send_invite_friends_mail(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :subject => "The class you signed up for is 3 days away and needs more students!")
  end

  def send_positive_confirmation(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :subject => "The class you signed up for is tomorrow!")
  end

  def send_negative_confirmation(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :subject => "The class you signed up for has been canceled")
  end

  def send_post_class_feedback(student, course)
    @student = student
    @course = course
    Time.zone = @student.time_zone
    mail(:to => @student.email, :subject => "Let us know how class went!")
  end

end