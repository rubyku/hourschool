class UserMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def contact_all_students(current_user,message,course)
    @course = course
    @message = message
    mail(:to => course.students.map(&:email), :subject => "Your teacher sent you a message!")
  end


  # course = Course.find(params[:id])
  # UserMailer.contact_teacher(user, course, "hello there").deliver
  def contact_teacher(current_user, course, message)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @message = message
    mail(:to => course.teacher.email, :subject => "A student sent you a message!")
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
