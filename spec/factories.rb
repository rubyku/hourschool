FactoryGirl.define do
  sequence :email do |n|
    "person_#{Time.now.to_i }@example.com"
  end

  sequence :class_name do
    hour_markov ||= %W{ have make a grow build community freedom
                        design programming color technique tables
                        chart grid salsa cook love you can today
                        easy quick sushi core work-out blast quick
                        fun viable scale fly to monster garden run
                        plant fish seed sustainable green natural}
    hour_markov.shuffle.first(rand(5)+3).map(&:capitalize).join(' ')
  end


  factory :role do
    user
    course
    role  { ['teacher', 'student'].sample }
  end


  factory :user do
    name      { "#{Random.firstname}  #{Random.lastname}"}
    email     { FactoryGirl.generate(:email) }
    zip       { Forgery(:address).zip }
    location  { "#{Forgery(:address).city}, #{Forgery(:address).state}" }
    time_zone "America/Chicago"
    password  { Forgery(:basic).password }
    bio       { Forgery(:lorem_ipsum).words(rand(10)) }
  end



  factory :course do
    title       { FactoryGirl.generate(:class_name) }
    description { Forgery(:lorem_ipsum).words(rand(30) + 1) }
    status      "live"
    place_name  { Forgery::Name.location }
    time_range  {c = rand(5); "#{c} - #{c + rand(2)}}"}
    price       { rand(100) }
    max_seats   { rand(10) }
    time        3.weeks.from_now
    date        3.weeks.from_now
    min_seats   { rand(5) }
  end
end
