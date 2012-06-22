# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pre_mission_signup do
    email "MyString"
    mission "MyString"
    description "MyText"
    user nil
  end
end
