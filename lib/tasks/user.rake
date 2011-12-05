
namespace :user do
  desc "finds missing zip codes and populates them"
  task :populate_missing_zip_codes => :environment do
    User.find_each(:conditions => "zip is null") do  |user|
      puts "========================="
      puts user.id
      zip = Geokit::Geocoders::GoogleGeocoder.geocode(user.city).zip || 78727
      puts zip
      user.zip = zip
      puts user.save
      sleep 2
    end
  end
end
