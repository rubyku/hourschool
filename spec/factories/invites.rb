# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    inviter nil
    invitee nil
    message "MyText"
    invitable nil
    invitable_type "MyString"
    invite_action "MyString"
  end
end
