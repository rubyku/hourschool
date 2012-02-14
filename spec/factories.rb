FactoryGirl.define do
  sequence :email do |n|
    "person_#{ Time.now.to_i }_#{n}@example.com"
  end

  sequence :course_name do
    hour_markov ||= %W{ have make a grow build community freedom
                        design programming color technique tables
                        chart grid salsa cook love you can today
                        easy quick sushi core work-out blast quick
                        fun viable scale fly to monster garden run
                        plant fish seed sustainable green natural}
    hour_markov.shuffle.first(rand(5)+3).map(&:capitalize).join(' ')
  end


  factory :role do
    association :user
    association :course
    name  { ['teacher', 'student'].sample }
  end

  # factory :teacher, :parent => :user do
  #   association :role, :name => 'teacher'
  # end

  factory :city do
    zip   { Forgery(:address).zip   }
    name  { Forgery(:address).city  }
    state { Forgery(:address).state }
    lat   { 39.999 } # Faker::Geolocation.lat
    lng   { 39.999 } # Faker::Geolocation.lat
  end


  factory :comment do
    user
    course
    body    { Forgery(:lorem_ipsum).words(rand(5 + 1)) }
  end


  factory :user do
    name          { "#{Random.firstname}  #{Random.lastname}"}
    email         { FactoryGirl.generate(:email) }
    zip           { Forgery(:address).zip }
    location      { "#{Forgery(:address).city}, #{Forgery(:address).state}" }
    time_zone     "America/Chicago"
    password      { Forgery(:basic).password }
    bio           { Forgery(:lorem_ipsum).words(rand(10)) }
    confirmed_at  { Time.now }
  end


  factory :course_with_teacher, :parent => :course do
    teacher {|course| FactoryGirl.build(:user) }
  end


  factory :course do
    association :city
    title       { FactoryGirl.generate(:course_name) }
    teaser      { Forgery(:lorem_ipsum).words(rand(5) + 1) }
    experience  { Forgery(:lorem_ipsum).words(rand(30) + 1) }
    description { Forgery(:lorem_ipsum).words(rand(30) + 1) }
    public      { [true, false].sample }
    status      "live"
    address     { Faker::Address.street_address }
    place_name  { Forgery::Name.location }
    time_range  {c = rand(5); "#{c} - #{c + rand(2)}}"}
    price       { rand(100) }
    max_seats   { rand(10) }
    time        3.weeks.from_now
    date        3.weeks.from_now
    min_seats   { rand(5) }
  end
end
