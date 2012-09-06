class TeacherMailer < ActionMailer::Base
  default :from => "HourSchool <hello@hourschool.com>"

  def send_course_proposal_reminder(course, current_account)
    @course = course
    @teacher = course.teacher
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/preview/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/preview/#{@course.id}"
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "admin@hourschool.com", :subject => "Your class, #{@course.title}, has been approved, but you have not made it live yet!")
  end

  def send_invite_friends_mail(course, current_account)
    @course = course
    @teacher = course.teacher
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "admin@hourschool.com", :subject => "Your class needs more students!")
  end

  def send_positive_confirmation(course, current_account)
    @course = course
    @teacher = course.teacher
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "admin@hourschool.com", :subject => "Reminder: You're teaching #{@course.title} today!")
  end

  def send_negative_confirmation(course, current_account)
    @course = course
    @teacher = course.teacher
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "admin@hourschool.com", :subject => "#{@course.title} didn't get enough students")
  end

  def send_post_class_feedback(course, current_account)
    @course = course
    @teacher = course.teacher
    @account = current_account
    @url = @account.nil? ? "http://hourschool.com/courses/#{@course.id}" : "http://#{@account.subdomain}.hourschool.com/courses/#{@course.id}"
    Time.zone = @teacher.time_zone
    mail(:to => @teacher.email, :bcc => "admin@hourschool.com", :subject => "Let us know how class went!")
  end

end