require 'csv'
namespace :export do
  desc "generate CSV string of users connected to facebook and their classes"
  task :facebook_users => :environment do
    csv_string = CSV.generate do |csv|
      csv << ["user hourschool id", "user hourschool url", "user facebook id", "course hourschool id", "course title", "course url"]
      User.where('facebook_id is not null').each do |user|
        user.courses.each do |course|
          csv << [user.id, "http://www.hourschool.com/users/#{user.id}", user.facebook_id, course.id, course.title, "http://www.hourschool.com/courses/#{course.slug}"]
        end
      end
    end
    puts csv_string
  end
end