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
   
   def send_nominate_mail_to_teacher(user_email, current_user, csuggid, message)
      @email = user_email
      @user = current_user
      @req = Csuggestion.find(csuggid)
      @url = "http://turunga.org/courses/new?req=#{@req.id}"
      @message = message
      mail(:to => user_email, :subject => "#{@user.name} has nominated you to teach at HourSchool")
    end
  
end
