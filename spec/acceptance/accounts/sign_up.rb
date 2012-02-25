require 'spec_acceptance_helper'

feature "Acceptance Accounts Sign Up" do
  let(:account)         { Factory.create(:account) }
  let(:user_attributes) { Factory.attributes_for(:user) }


  describe 'a restricted Account' do
    scenario 'fails unless has a specific email' do
      geo_name_web_mock
      user_count = User.count
      visit new_user_registration_url(:subdomain => account.subdomain)
      fill_in  'user_name',     :with => user_attributes[:name]
      fill_in  'user_zipcode',  :with => user_attributes[:zip]
      fill_in  'user_email',    :with => "not_valid_account@nope.com"
      fill_in  'user_password', :with => user_attributes[:password]
      fill_in  'user_password_confirmation', :with => user_attributes[:password]
      click_on 'user_submit'
      ## user count should not change
      User.count.should == user_count
    end

    scenario 'passes when correct email is used' do
      geo_name_web_mock
      user_count = User.count
      visit new_user_registration_url(:subdomain => account.subdomain)
      fill_in  'user_name',     :with => user_attributes[:name]
      fill_in  'user_zipcode',  :with => user_attributes[:zip]
      fill_in  'user_email',    :with => "foo_#{Time.now.to_i}@#{account.subdomain}.com"
      fill_in  'user_password', :with => user_attributes[:password]
      fill_in  'user_password_confirmation', :with => user_attributes[:password]
      click_on 'user_submit'
      ## user count should change
      User.count.should > user_count
    end
  end
end
