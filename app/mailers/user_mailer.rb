class UserMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  layout 'layouts/email_layout'


  def ticket_invite(options = {})
    @user     = options[:user]
    @role     = options[:role]
    @inviter  = options[:inviter]
    @course   = @role.course
    @account  = @role.course.account
    mail :to        => @user.email,
         :bcc       => "admin@hourschool.com",
         :from      => "#{@inviter.name} <hello@hourschool.com>",
         :reply_to  => @inviter.email,
         :subject   => "#{@inviter.name} bought you a ticket to #{@course.name}"
  end

  # course = Course.find(params[:id])
  # UserMailer.contact_teacher(user, course, "hello there").deliver
  def contact_teacher(user, course, message,current_account)
    @email = course.teacher.email
    @user = user
    @course = course
    @message = message
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => course.teacher.email,
         :bcc => "admin@hourschool.com",
         :reply_to => user.email,
         :subject => "#{@user.name} left you a message about your event"
  end

  def contact_all_students(user,course,message, current_account)
    raise "Must be sent by teacher" unless user == course.teacher
    @course = course
    @message = message
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => course.students.map(&:email),
         :bcc => "admin@hourschool.com",
         :reply_to => course.teacher.email,
         :subject => "Your teacher sent a message about your event"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  def course_comments(user, comment, course, current_account)
    @user    = user
    @course  = course
    @comment = comment
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => user.email,
         :bcc => "admin@hourschool.com",
         :subject => "#{comment.user.name} left you a comment about your event"
  end

  def course_feedback(user, course, students, general_feedback)
    @email = course.teacher.email
    @user = user
    @course = course
    @students = students
    @general_feedback = general_feedback
    mail :to => "admin@hourschool.com",
         :subject => "#{@user.name} submitted a feedback form!"
  end

  def course_live(user_email, user_name, course, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => user_email,
         :bcc => "admin@hourschool.com",
         :subject => "#{@course.title} is live!"
  end

  def course_registration(user_email, user_name, course, role, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    @role    = role
    @price = @role.member? ? @course.member_price : @course.price
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => user_email,
         :bcc => "admin@hourschool.com",
         :subject => "You've signed up for #{@course.title}!"
  end

  def course_registration_to_teacher(user_email, user_name, course, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => @course.teacher.email,
         :subject => "Someone signed up for #{@course.title}!"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  # def followed_created_a_course(user, followed, course)
  #   @user     = user
  #   @followed = followed
  #   @course   = course
  #   mail(:to => user.email, :subject => "#{@followed.name} just created a new course on Hourschool")
  # end
  #
  # def followed_signed_up_for_a_course(user, followed, course)
  #   @user     = user
  #   @followed = followed
  #   @course   = course
  #   mail(:to => user.email, :subject => "#{@followed.name} just signed up for a course on Hourschool")
  # end

  #----------------------------------------------------------------------------------------------------------------------------

  def membership_invitation(user, account, inviter, existing_user)
    @user = user
    @account = account
    @existing_user = existing_user
    mail :to => user.email,
         :bcc => "admin@hourschool.com",
         :subject => "#{inviter.name} wants you to join #{account.name}"
  end

  def user_invite_to_course(options = {})
    @inviter        = options[:inviter]
    @course         = options[:course]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    @account        = current_account
    @account_name   = @account.try(:name) || "HourSchool"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => @invitee_email,
         :bcc => "admin@hourschool.com",
         :subject => "#{@inviter.name} invited you to an event"
  end

#----------------------------------------------------------------------------------------------------------------------------
  #Account notifications for Account admin

  def new_account(user, account)
    @user       = user
    @account    = account
    @url = @account.nil? ? "http://hourschool.com/courses/new" : "http://#{@account.subdomain}.hourschool.com/courses/new"
    mail :to => @user.email,
         :bcc => "admin@hourschool.com, coreteam@hourschool.com",
         :subject => "Congratulations! #{@account.name} is live!"
  end

  def account_new_member(user, account, new_member)
    @account    = account
    @user       = user
    @new_member = new_member
    mail :to => @user.email,
         :bcc => "admin@hourschool.com",
         :subject => "#{@new_member.name} joined #{@account.name}"
  end

  #Account notifications for Account members

  def account_new_course(user, account, new_course)
    @account    = account
    @user       = user
    @new_course = new_course
    mail :from => "#{@account.name} <hello@hourschool.com>",
         :to => @user.email,
         :bcc => "admin@hourschool.com",
         :subject => "[New event]: #{@new_course.title}"
  end

  def account_new_comment(user, account, new_comment)
    @account     = account
    @user        = user
    @new_comment = new_comment
    mail :from => "#{@account.name} <hello@hourschool.com>",
         :to => @user.email,
         :bcc => "admin@hourschool.com",
         :subject => "#{@new_comment.user} left a new comment"
  end


  #----------------------------------------------------------------------------------------------------------------------------

  def user_registration(user_email,user_name, current_account)
    @email = user_email
    @name = user_name
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    subject = @account.nil? ? "Welcome to HourSchool" : "Welcome to #{@account.name}"
    mail :from => "#{@account_name} <hello@hourschool.com>",
         :to => user_email,
         :subject => subject
  end

  #----------------------------------------------------------------------------------------------------------------------------

  class Preview < MailView
    # Pull data from existing fixtures

    def mission_new_member
      mission = Mission.find(1)
      user = User.find(1)
      new_member = User.find(2)
      UserMailer.mission_new_member(user, mission, new_member)
    end

    def send_course_registration_mail
      user   = User.last
      course = Course.first
      current_account = nil
      UserMailer.send_course_registration_mail(user.email, user.name, course, current_account)
    end

    def invite_nonuser_to_course
      inviter   = User.last
      invitee   = User.first
      course  = Course.last
      UserMailer.invite_nonuser_to_course(:inviter => inviter, :invitee_email => invitee.email, :course => course)
    end

  end

end
