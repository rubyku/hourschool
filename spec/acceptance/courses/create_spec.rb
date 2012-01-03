require 'spec_acceptance_helper'

feature "Acceptance courses#create" do


  describe 'teach page' do
    pending
    scenario 'works logged out' do
      as_visitor.visit teach_path
      successfully_renders
    end

    scenario 'works while logged in' do
      as_user.visit teach_path
      successfully_renders
    end
  end
  
  describe 'creating a class' do
    pending
    scenario '' do
      user        = Factory.create(:user)
      course_stub = Factory.stub(:course)
      as_user(user) do
        visit teach_path
        save_and_open_page
        click_link('Create')
        current_path.should == new_course_path
        fill_in('course_title',      :with => course_stub.title)
        fill_in('course_teaser',     :with => course_stub.teaser)
        fill_in('course_experience', :with => course_stub.experience)
        click('Submit')
        save_and_open_page
      end
    end
    
  end

end
