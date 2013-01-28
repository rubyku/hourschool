require 'spec_acceptance_helper'

feature "signing up for a course" do
  let(:user)    {Factory.create(:user)}
  let(:course)  {Factory.create(:course)}

  describe 'index page' do
    scenario 'works logged out' do
      as_user(user) do
        visit course_path(course)
        click_button "Sign me up!"
        "Register for this session"
      end
      as_visitor.visit learn_path
      successfully_renders
    end

    scenario 'works while logged in' do
      as_user(user).visit learn_path
      successfully_renders
    end
  end

end
