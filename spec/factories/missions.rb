# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mission do
    title "MyString"
    description "MyText"
    account nil
    city nil
  end
end
