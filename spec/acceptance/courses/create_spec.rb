require 'spec_acceptance_helper'

feature "Acceptance courses#create" do
  let(:user) {Factory.create(:user)}

  describe 'teach page' do

    scenario 'works logged out' do
      as_visitor.visit teach_path
      successfully_renders
    end

    scenario 'works while logged in' do
      as_user(user).visit teach_path
      successfully_renders
    end
  end

  describe 'creating a class' do
    scenario '' do
      course_stub = Factory.stub(:course)
      as_user(user) do
        visit teach_path
        click_link('Create')
        current_path.should == new_course_path
        fill_in('course_title',      :with => course_stub.title)
        fill_in('course_teaser',     :with => course_stub.teaser)
        fill_in('course_experience', :with => course_stub.experience)
        click_button('Submit')
        save_and_open_page
      end
    end

  end

end
