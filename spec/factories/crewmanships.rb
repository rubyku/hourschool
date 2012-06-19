# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crewmanship do
    mission nil
    user nil
    role "MyString"
    status "MyString"
    trial_expires_at "2012-06-19 10:59:58"
    canceled_at "2012-06-19 10:59:58"
  end
end
