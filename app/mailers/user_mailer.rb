class UserMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def contact_all_students(current_user,course,message)
    @course = course
    @message = message
    mail(:to => course.students.map(&:email), :reply_to => course.teacher.email, :subject => "Your teacher sent you a message!")
  end

  def comment_on_course(user, comment, course)
    @user    = user
    @course  = course
    @comment = comment
    mail(:to => user.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{comment.user.name} left a comment on Hourschool")
  end

  # course = Course.find(params[:id])
  # UserMailer.contact_teacher(user, course, "hello there").deliver
  def contact_teacher(current_user, course, message)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @message = message
    mail(:to => course.teacher.email, :reply_to => current_user.email, :subject => "A student sent you a message!")
  end

  def feedback(current_user, course, students, general_feedback)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @students = students
    @general_feedback = general_feedback
    mail(:to => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{@user.name} submitted a feedback form!")
  end

  def send_registration_mail(user_email,user_name)
    @email = user_email
    @name = user_name
    mail(:to => user_email, :subject => "Welcome to HourSchool!")
  end

   def send_course_registration_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => user_email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "You've signed up for #{@course.title}!")
   end

   def send_course_registration_to_teacher_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => @course.teacher.email, :subject => "Someone signed up for your #{@course.title} class!")
   end

   def send_course_reskilling_mail(user_email, name, course)
     @course = course
     @name   = name
     mail(:to => user_email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "Thank you for your interest!")
   end

   def send_proposal_received_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => user_email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{@course.title} is submitted!")
   end

   def send_course_approval_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => user_email, :subject => "#{@course.title} is approved!")
   end

   def send_class_live_mail(user_email, user_name, course)
     @email = user_email
     @name = user_name
     @course = course
     mail(:to => user_email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{@course.title} is live!")
   end

   def send_nominate_mail_to_teacher(user_email, current_user, csuggid, message)
      @email = user_email
      @user = current_user
      @req = Suggestion.find(csuggid)
      @url = "http://www.hourschool.com/courses/new?req=#{@req.id}"
      @message = message
      mail(:to => user_email, :reply_to => @user.email, :bcc => "alex@hourschool.com, ruby@hourschool.com", :subject => "#{@user.name} has nominated you to teach at HourSchool")
   end

   def send_nominate_mail_to_hourschool(user_email, current_user, csuggid, message)
      @email = user_email
      @user = current_user
      @req = Suggestion.find(csuggid)
      @url = "http://www.hourschool.com/courses/new?req=#{@req.id}"
      @message = message
      mail(:to => "ruby@hourschool.com, alex@hourschool.com", :subject => "A nomination!")
   end

   def send_suggestion_received_to_hourschool_mail(user_email, user_name, suggestion)
     @email = user_email
     @name = user_name
     @suggestion = suggestion
     mail(:to => "ruby@hourschool.com, alex@hourschool.com", :subject => "A suggestion has been submitted!")
   end

   def simple(options)
     @body = options[:body].to_s
     mail(options)
   end

end
