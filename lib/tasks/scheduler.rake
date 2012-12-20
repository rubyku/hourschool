desc "Send scheduled emails"
namespace :schedule do

  task :trial_expired => :environment do
    # email people 3 days before trial is going to expire
    trial_expires_in_3_days = Crewmanship.where(:status => "trial", :expires_at => 3.days.from_now)
    trial_expires_in_3_days.each do |trial|
      UserMailer.send_expiration_3_day_reminder(trial).deliver
    end
    # email people the day their trial expires
    trial_expires_today = Crewmanship.where(:status => "trial", :expires_at => Date.now)
    trial_expires_today.each do |trial|
      UserMailer.send_expiration_today_reminder(trial).deliver
    end
  end

  task :schedule_events => :environment do
    ScheduleEvent.where("DATE(publish_on) <= DATE(:today) and published = false", :today => Date.today).each do |event|
      event.publish!
    end
  end


  task :generate_sitemap => :environment do
    SitemapGenerator::Sitemap.sitemaps_host = "https://s3.amazonaws.com/hourschool-sitemap/"
    SitemapGenerator::Sitemap.public_path = 'tmp/'
    SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
    SitemapGenerator::Sitemap.adapter = SitemapGenerator::WaveAdapter.new

    SitemapGenerator::Sitemap.default_host = 'http://www.hourschool.com'
    SitemapGenerator::Sitemap.create do
      Course.find_each do |course|
        add course_path(course), :changefreq => 'daily'
      end
    end
    SitemapGenerator::Sitemap.ping_search_engines # called for you when you use the rake task
  end

  task :send_class_proposal_reminder_emails => :environment do
    puts "Sending class proposal reminder emails..."
    pending_courses = Course.where("status = ? AND updated_at < ? AND updated_at > ?", "approved", 7.days.ago, 8.days.ago)
    pending_courses.each do |course|
      if course.account.nil?
        current_account = nil
      else
        current_account = course.account
      end
        TeacherMailer.send_course_proposal_reminder(course, current_account).deliver
    end
    puts "done"
  end

  task :send_72hr_invite_friends_emails => :environment do
    puts "Sending 72 hr reminder emails..."
    courses_in_3_days = Course.where("date = :todays_date AND status = :live", {:todays_date => 3.days.from_now, :live => "live"})
    courses_in_3_days.each do |course|
      students = course.students
      if course.account.nil?
        current_account = nil
      else
        current_account = course.account
      end
      if students.size < course.min_seats
        TeacherMailer.send_invite_friends_mail(course, current_account).deliver
        students.each do |student|
          StudentMailer.send_invite_friends_mail(student,course, current_account).deliver
        end
      end
    end
    puts "done"
  end

  task :send_day_of_reminder_emails => :environment do

    puts "Sending day of reminder emails..."

    courses_today = Course.where("DATE(starts_at) = DATE(?)", Time.zone.now.to_date-1.day).where(:status => 'live')

    courses_today.each do |course|
      students = course.students
      if course.account.nil?
        current_account = nil
      else
        current_account = course.account
      end
      if students.size >= course.min_seats
        TeacherMailer.send_positive_confirmation(course, current_account).deliver
        students.each do |student|
          StudentMailer.send_positive_confirmation(student, course, current_account).deliver
        end
      else
        TeacherMailer.send_negative_confirmation(course).deliver
        # students.each do |student|
        #   StudentMailer.send_negative_confirmation(student, course).deliver
        # end
      end
    end
    puts "done"
  end

  task :fill_followings_post_class => :environment do
    puts "Auto Following Students from Yesterdays course..."
    courses_yesterday = Course.where("(:yesterdays_date = date) AND status = :live", {:yesterdays_date => Date.yesterday, :live => "live"})
    courses_yesterday.each do |course|
      students = course.students
      if students.size >= course.min_seats
        students.each do |student|
          student.fill_following_for_course!(course)
        end
      end
    end
    puts "done"
  end

  task :send_post_class_emails => :environment do
    puts "Sending post-class feedback emails..."
    courses_yesterday = Course.where("(:yesterdays_date = date) AND status = :live", {:yesterdays_date => Date.yesterday, :live => "live"})
    courses_yesterday.each do |course|
      students = course.students
      if course.account.nil?
        current_account = nil
      else
        current_account = course.account
      end
      if students.size >= course.min_seats
        TeacherMailer.send_post_class_feedback(course, current_account).deliver
        students.each do |student|
          StudentMailer.send_post_class_feedback(student, course, current_account).deliver
        end
      end
    end
    puts "done"
  end

  task :send_nominee_reminder_emails => :environment do
    puts "Sending nominated teacher reminders..."
    # TODO: Use Roles - Need course/suggestion integration

    puts "not implemented"
  end
end