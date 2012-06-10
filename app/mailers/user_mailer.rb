class UserMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"
  

  # def followed_created_a_course(current_user, followed, course)
  #   @user     = current_user
  #   @followed = followed
  #   @course   = course
  #   mail(:to => current_user.email, :subject => "#{@followed.name} just created a new course on Hourschool")
  # end
  # 
  # def followed_signed_up_for_a_course(current_user, followed, course)
  #   @user     = current_user
  #   @followed = followed
  #   @course   = course
  #   mail(:to => current_user.email, :subject => "#{@followed.name} just signed up for a course on Hourschool")
  # end

  def comment_on_course(user, comment, course, current_account)
    @user    = user
    @course  = course
    @comment = comment
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail(:to => user.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{comment.user.name} left you a comment about your class")
  end

  # course = Course.find(params[:id])
  # UserMailer.contact_teacher(user, course, "hello there").deliver
  def contact_teacher(current_user, course, message)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @message = message
    mail(:to => course.teacher.email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :reply_to => current_user.email, :subject => "#{@user.name} left you a message about your class")
  end

  def contact_all_students(current_user,course,message)
    @course = course
    @message = message
    mail(:to => course.students.map(&:email), :bcc => "ruby@hourschool.com, alex@hourschool.com", :reply_to => course.teacher.email, :subject => "Your teacher sent a message about your class")
  end

  def feedback(current_user, course, students, general_feedback)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @students = students
    @general_feedback = general_feedback
    mail(:to => "ruby@hourschool.com, alex@hourschool.com", :subject => "#{@user.name} submitted a feedback form!")
  end

  def send_registration_mail(user_email,user_name, current_account)
    @email = user_email
    @name = user_name
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    subject = @account.nil? ? "Welcome to HourSchool" : "Welcome to #{@account.name}"
    mail(:to => user_email, :subject => subject)
  end

   def send_course_registration_mail(user_email, user_name, course, current_account)
     @email = user_email
     @name = user_name
     @course = course
     @account = current_account
     @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
     mail(:to => user_email, :bcc => "ruby@hourschool.com, alex@hourschool.com", :subject => "You've signed up for #{@course.title}!")
   end

   def send_course_registration_to_teacher_mail(user_email, user_name, course, current_account)
     @email = user_email
     @name = user_name
     @course = course
     @account = current_account
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

   def send_course_approval_mail(user_email, user_name, course, current_account)
     @email = user_email
     @name = user_name
     @course = course
     @account = current_account
     @url = @account.nil? ? "http://hourschool.com/preview/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/preview/#{@course.id}"
     mail(:to => user_email, :subject => "#{@course.title} is approved!")
   end

   def send_class_live_mail(user_email, user_name, course, current_account)
     @email = user_email
     @name = user_name
     @course = course
     @account = current_account
     @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
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

  def invitation(user, account, inviter, existing_user)
    @user = user
    @account = account
    @existing_user = existing_user
    mail :to => user.email,
         :bcc => "ruby@hourschool.com, alex@hourschool.com",
         :subject => "#{inviter.name} wants you to join #{account.name}"
  end

   def simple(options)
     @body = options[:body].to_s
     mail(options)
   end

end
