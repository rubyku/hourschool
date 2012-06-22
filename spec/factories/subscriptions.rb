# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    subscribable_type "MyString"
    subscribable_id 1
    stripe_customer_id "MyString"
  end
end
