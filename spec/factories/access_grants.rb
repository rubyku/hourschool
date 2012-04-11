# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :access_grant do
    code "MyString"
    access_token "MyString"
    refresh_token "MyString"
    access_token_expires_at "2012-03-09 19:10:34"
    user_id 1
    application_id 1
  end
end
