require 'spec_acceptance_helper'

feature "Acceptance Sessions" do
  let(:visitor)  { Factory.create(:user) }
  let(:admin)    { Factory.create(:user, :admin => true) }


  describe 'manual creation' do
    scenario 'gets redirected back to original path after signin' do
      original_path = admin_charts_path
      visit original_path                               # requires authentication
      current_path.should == new_user_session_path      # redirect to sign in path
      fill_in  'user_email',    :with => admin.email
      fill_in  'user_password', :with => admin.password
      click_on 'user_submit'
      current_path.should == original_path              # send em' back
    end
  end

end
