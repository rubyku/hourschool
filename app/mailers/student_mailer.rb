class StudentMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"
  
  def send_invite_friends_mail(student, course)
    @student = student
    @course = course
    mail(:to => @student.email, :subject => "The class you signed up for is 3 days away and needs more students!")    
  end
  
  def send_positive_confirmation(student, course)
    @student = student
    @course = course
    mail(:to => @student.email, :subject => "The class you signed up for is tomorrow!")
  end
  
  def send_negative_confirmation(student, course)
    @student = student
    @course = course
    mail(:to => @student.email, :subject => "The class you signed up for has been canceled!")    
  end

  def send_post_class_feedback(student, course)
    @student = student
    @course = course
    mail(:to => @student.email, :subject => "Thanks for using Hourschool! We appreciate your feedback")      
  end
  
end