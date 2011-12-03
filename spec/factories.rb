FactoryGirl.define do
  factory :user
  factory :course do
    title       { Forgery(:lorem_ipsum).words(rand(4) + 1) }
    description { Forgery(:lorem_ipsum).words(rand(30) + 1) }
    status      "live"
    place       "who ville"
    time_range  {rand(5).to_s}
    price       { rand(100) }
    seats       { rand(10) }
    time        3.weeks.from_now
    date        3.weeks.from_now
    minimum     { rand(5) }
  end
end