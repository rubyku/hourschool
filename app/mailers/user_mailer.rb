class UserMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  layout 'layouts/email_layout'


  # course = Course.find(params[:id])
  # UserMailer.contact_teacher(user, course, "hello there").deliver
  def contact_teacher(current_user, course, message)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @message = message
    mail :to => course.teacher.email,
         :bcc => "hello@hourschool.com",
         :reply_to => current_user.email,
         :subject => "#{@user.name} left you a message about your event"
  end

  def contact_all_students(current_user,course,message)
    @course = course
    @message = message
    mail :to => course.students.map(&:email),
         :bcc => "hello@hourschool.com",
         :reply_to => course.teacher.email,
         :subject => "Your teacher sent a message about your event"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  def course_comments(user, comment, course, current_account)
    @user    = user
    @course  = course
    @comment = comment
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :to => user.email,
         :bcc => "hello@hourschool.com",
         :subject => "#{comment.user.name} left you a comment about your event"
  end

  def course_feedback(current_user, course, students, general_feedback)
    @email = course.teacher.email
    @user = current_user
    @course = course
    @students = students
    @general_feedback = general_feedback
    mail :to => "hello@hourschool.com",
         :subject => "#{@user.name} submitted a feedback form!"
  end

  def course_live(user_email, user_name, course, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :to => user_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@course.title} is live!"
  end

  def course_registration(user_email, user_name, course, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    mail :to => user_email,
         :bcc => "hello@hourschool.com",
         :subject => "You've signed up for #{@course.title}!"
  end

  def course_registration_to_teacher(user_email, user_name, course, current_account)
    @email = user_email
    @name = user_name
    @course = course
    @account = current_account
    mail :to => @course.teacher.email,
         :subject => "Someone signed up for #{@course.title}!"
  end

  #----------------------------------------------------------------------------------------------------------------------------

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

  #----------------------------------------------------------------------------------------------------------------------------

  def membership_invitation(user, account, inviter, existing_user)
    @user = user
    @account = account
    @existing_user = existing_user
    mail :to => user.email,
         :bcc => "hello@hourschool.com",
         :subject => "#{inviter.name} wants you to join #{account.name}"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  def mission_new_member(user, mission, new_member)
    @mission    = mission
    @user       = user
    @new_member = new_member
    mail :to => @user.email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@new_member.name} joined #{@mission.verb} #{@mission.title}"
  end

  def mission_new_course(user, mission, new_course)
    @mission    = mission
    @user       = user
    @new_course = new_course
    mail :to => @user.email,
         :bcc => "hello@hourschool.com",
         :subject => "New event: #{@mission.verb} #{@mission.title}"
  end

  def mission_new_comment(user, mission, new_comment)
    @mission     = mission
    @user        = user
    @new_comment = new_comment
    mail :to => @user.email,
         :bcc => "hello@hourschool.com",
         :subject => "New comment: #{@mission.verb} #{@mission.title}"
  end

  def mission_new_topic(user, mission, new_topic)
    @mission    = mission
    @user       = user
    @new_topic  = new_topic
    mail :to => @user.email,
         :bcc => "hello@hourschool.com",
         :subject => "New topic: #{@mission.verb} #{@mission.title}"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  def user_invite_to_mission(options = {})
    @inviter        = options[:inviter]
    @mission        = options[:mission]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter.name} invited you to a mission!"
  end

  def nonuser_invite_to_mission(options = {})
    @inviter_name   = options[:inviter_name]
    @inviter_email  = options[:inviter_email]
    @mission        = options[:mission]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter_name} invited you to a mission!"
  end

  def user_invite_to_course(options = {})
    @inviter        = options[:inviter]
    @course         = options[:course]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter.name} invited you to an event"
  end

  def nonuser_invite_to_course(options = {})
    @inviter_name   = options[:inviter_name]
    @inviter_email  = options[:inviter_email]
    @course         = options[:course]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter_name} invited you to an event"
  end

  def user_invite_to_topic(options = {})
    @inviter        = options[:inviter]
    @topic          = options[:topic]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter.name} invited you to organize an event"
  end

  def nonuser_invite_to_topic(options = {})
    @inviter_name   = options[:inviter_name]
    @inviter_email  = options[:inviter_email]
    @topic          = options[:topic]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter_name} invited you to organize an event"
  end

  def user_invite_to_comment(options = {})
    @inviter        = options[:inviter]
    @comment        = options[:comment]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter.name} invited you to answer a question"
  end

  def nonuser_invite_to_comment(options = {})
    @inviter_name   = options[:inviter_name]
    @inviter_email  = options[:inviter_email]
    @comment        = options[:comment]
    @invitee_email  = options[:invitee_email]
    @invitable_type = options[:invitable_type]
    @invitable_id   = options[:invitable_id]
    @message        = options[:message]
    mail :to => @invitee_email,
         :bcc => "hello@hourschool.com",
         :subject => "#{@inviter_name} invited you to answer a question"
  end

  #----------------------------------------------------------------------------------------------------------------------------

  def user_registration(user_email,user_name, current_account)
    @email = user_email
    @name = user_name
    @account = current_account
    @account_name = @account.try(:name) || "HourSchool"
    subject = @account.nil? ? "Welcome to HourSchool" : "Welcome to #{@account.name}"
    mail(:to => user_email, :subject => subject)
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
