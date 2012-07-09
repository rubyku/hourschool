require 'spec_acceptance_helper'

feature "User can join mission" do
  let(:user)        {Factory.create(:user) }
  let(:mission)     {Factory.create(:mission) }


  scenario 'a user joins a mission and gets a 30 day free trial' do
    as_user(user) do
      visit mission_path(mission)
      click_link 'Become a member'
      successfully_renders

      click_button 'Make it happen!'
      successfully_renders

      crewmanship = user.crewmanships.first
      user.missions.include?(mission).should == true
      crewmanship.status.should == 'trial_active'
      crewmanship.trial_expires_at.should == 30.days.from_now.to_date
    end
  end

  scenario 'a user (with an trial_active subscription) joins a 2nd mission, the crewmanships expire date is set to the first' do
  end

  scenario 'a user (with a canceled subscription) joins 2nd mission, charge right away, make status active, and make today the billing day' do
  end

  scenario "a user (with an active subscription) joins a 2nd mission, it becomes active but is not billed until the next billing day" do
  end

  # "a user's trial expires tomorrow, but they can add their payment info today"

  # "a user's trial expires, they enter their payment info, and are charged"

  # "a user's who has a past_due crewmanship, can bring their account current"

  # "a user with a canceled crewmanship"
end