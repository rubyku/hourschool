namespace :subscriptions do
  desc "find crewmanships who's trial expires today and mark them active or expired"
  task :activate_or_expire_crewmanships => :enviroment do
    Crewmanship.activate_or_expire_crewmanships
  end

  desc "find users whose crewmanships expire in 3 days and dont have payment info and email them to enter it"

  desc "find users who's invoice date is today and charge them for any active crewmanships"
  task :charge => :enviroment do
    User.monthly_charge
  end
end