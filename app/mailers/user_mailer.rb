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
  
  def send_course_approval_mail(user_email, user_name, course)
    @email = user_email
    @name = user_name
    @course = course
    mail(:to => user_email, :subject => "Your proposal has been approved!")
  end
  
  def send_course_registration_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => user_email, :subject => "You have registered for a course!")
   end
  
end
