require 'spec_acceptance_helper'

feature "Register new account" do
  let(:user_attributes) { Factory.attributes_for(:user) }

  describe 'Creating an Account' do
    scenario 'works' do
      geo_name_web_mock
      visit new_user_registration_path
      fill_in  'user_name',     :with => user_attributes[:name]
      fill_in  'user_zipcode',  :with => user_attributes[:zip]
      fill_in  'user_email',    :with => user_attributes[:email]
      fill_in  'user_password', :with => user_attributes[:password]
      fill_in  'user_password_confirmation', :with => user_attributes[:password]
      click_on 'user_submit'
      current_path.should_not == new_user_registration_path
    end
  end

end
