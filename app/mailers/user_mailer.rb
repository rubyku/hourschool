class UserMailer < ActionMailer::Base
  default :from => "hello@hourschool.com"
  
  def contact_all_students(subject,message,course)
    @course = course
    mail(:to => course.students.map(&:email), :subject => subject)
  end
  
  def contact_teacher(subject, message, course)
    @course = course
    mail(:to => course.teacher.email, :subject => subject)
  end
  
  def send_registration_mail(user_email,user_name)
    @email = user_email
    @name = user_name
    mail(:to => user_email, :subject => "Welcome to HourSchool!")
  end
  
end
