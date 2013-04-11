require 'spec_acceptance_helper'

feature "signing up for a course" do
  let(:user)    {Factory.create(:user)}
  let(:course)  {Factory.create(:course, price: 10, max_seats: 10)}

  # describe 'index page' do
  #   scenario 'works logged out' do
  #     as_user(user) do
  #       visit course_path(course)
  #       click_button "Sign me up!"
  #       "Register for this session"
  #     end
  #     as_visitor.visit learn_path
  #     successfully_renders
  #   end

  #   scenario 'works while logged in' do
  #     as_user(user).visit learn_path
  #     successfully_renders
  #   end
  # end

  describe 'multiple tickets purchase' do
    scenario 'buying 2 tickets', js: true do
      pending("stripe, capybara, poltergeist weirdness")

      VCR.use_cassette('valid_stripe_payment') do
        course.roles.create(name: "teacher", user: FactoryGirl.create(:user))
        as_user(user) do

          visit new_course_attendee_registration_path(course_id: course.id)

          select('2', from: 'role_quantity')
          fill_in 'card_number',        with: STRIPE_CARD_SUCCESS
          fill_in 'card_cvc',           with: "323"
          fill_in 'card_expiry_month',  with: "2"
          fill_in 'card_expiry_year',   with: "2014"


          find_field('card_expiry_year').set("2014")

          expected_amount = course.price * 2

          assert_equal "2014", find_field('card_expiry_year').value


          click_button "continue_enabled"
          sleep 2
          save_and_open_page
        end
      end
    end
  end

end
