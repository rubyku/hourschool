require 'spec_acceptance_helper'

feature "Acceptance courses/browse" do
  after(:each) do
    Warden.test_reset!
  end

  let(:user) {Factory.create(:user)}

  describe 'index page' do
    scenario 'works logged out' do
      as_visitor.visit learn_path
      successfully_renders
    end

    scenario 'works while logged in' do
      as_user(user).visit learn_path
      successfully_renders
      save_and_open_page
    end
  end

end
