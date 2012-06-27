# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription_charge do
    user nil
    params "MyText"
    amount "9.99"
    paid false
    stripe_card_id "MyString"
    stripe_customer_id "MyString"
    stripe_id "MyString"
    card_last_4 "MyString"
    card_type "MyString"
  end
end
