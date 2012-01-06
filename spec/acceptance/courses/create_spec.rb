require 'spec_acceptance_helper'

feature "Acceptance courses#create" do
  let(:user)        {Factory.create(:user) }
  let(:course_stub) {Factory.stub(:course) }



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
    before(:each) do
      as_user(user) do
        visit teach_path
        click_link('Create')
        current_path.should == new_course_path
        fill_in 'course_title',       :with => course_stub.title
        fill_in 'course_teaser',      :with => course_stub.teaser
        fill_in 'course_experience',  :with => course_stub.experience
        click_button 'Submit'

        current_path.should == user_path(user)

        @course = Course.where(:title => course_stub.title).last
        visit edit_course_path(@course)
        current_path.should == edit_course_path(@course)
      end
    end


    scenario 'a user fills out a course proposal' do
      as_user(user) do
        fill_in 'course_description', :with => course_stub.description
        fill_in 'course_min_seats',   :with => course_stub.min_seats
        fill_in 'course_max_seats',   :with => course_stub.max_seats

        select course_stub.date.strftime("%Y") , :from => 'course_date_1i' # 2011
        select course_stub.date.strftime("%B") , :from => 'course_date_2i' # January
        select course_stub.date.strftime("%d") , :from => 'course_date_3i' # January

        fill_in 'course_time_range', :with => course_stub.time_range

        if course_stub.public?
          choose 'course_public_true'
        else
          choose 'course_public_false'
        end

        fill_in 'course_place_name', :with => course_stub.place_name
        fill_in 'course_address',    :with => course_stub.address
        fill_in 'course_price',      :with => course_stub.price

        click_button 'course_submit'

        current_path.should == preview_path(@course)

        click_button 'Publish now!'

        current_path.should == confirm_path(@course)
        successfully_renders

        @course = Course.where(:title => course_stub.title).last

        @course.description.should   == course_stub.description
        @course.min_seats.should     == course_stub.min_seats
        @course.max_seats.should     == course_stub.max_seats
        @course.public?.should        == course_stub.public?
        @course.place_name.should    == course_stub.place_name
        @course.address.should       == course_stub.address
        @course.price.should         == course_stub.price

      end
    end

  end

end
