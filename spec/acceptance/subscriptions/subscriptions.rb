require 'spec_acceptance_helper'

feature "User can join mission" do
  let(:user)        {Factory.create(:user) }
  let(:mission)     {Factory.create(:mission) }


  scenario 'a user joins a mission and gets a 30 day free trial' do
    as_user(user) do
      visit mission_path(mission)
      click_link 'Become a member'

      click_button 'Make it happen!'

      crewmanship = user.crewmanships.first
      user.missions.include?(mission).should == true
      crewmanship.status.should == 'trial_active'
      crewmanship.trial_expires_at.should == 30.days.from_now.to_date
    end
  end

  scenario 'a user (with an trial_active crewmanship) joins a 2nd mission, the crewmanships expire date is set to the first' do
    first_crewmanship = user.crewmanships.create!(:status => 'trial_active', :trial_expires_at => 2.days.from_now.to_date)
    as_user(user) do
      visit mission_path(mission)
      click_link 'Become a member'

      click_button 'Make it happen!'

      crewmanship = user.crewmanships.first
      crewmanship.trial_expires_at.should == first_crewmanship.trial_expires_at
    end
  end

  scenario 'a user (with a active crewmanship) joins 2nd mission, make status active and charge on next billing date' do
    teacher = Factory.create(:user)
    course = Factory.create(:course, :mission => mission)
    Factory.create(:role, :user => teacher, :course => course, :name => 'teacher')
    course.update_attribute(:starts_at, 1.day.ago)

    mission2 = Factory.create(:mission)
    course = Factory.create(:course, :mission => mission2)
    course.update_attribute(:starts_at, 1.day.ago)
    Factory.create(:role, :user => teacher, :course => course, :name => 'teacher')

    first_crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
    as_user(user) do
      visit mission_path(mission2)
      click_link 'Become a member'

      click_button 'Make it happen!'

      crewmanship = user.crewmanships.order('id asc').last
      crewmanship.status.should == 'active'
      user.balance == 20.00
    end
  end

  scenario 'a user (with a canceled crewmanship) joins 2nd mission, charge right away, make status active, and make today the billing day' do
    mock_stripe(true)
    user.create_stripe_customer({
      :card => {
        :number => 4242424242424242,
        :exp_month => 01,
        :exp_year => Time.now.year+1
      }
    })
    first_crewmanship = user.crewmanships.create!(:status => 'canceled')
    as_user(user) do
      visit mission_path(mission)
      click_link 'Become a member'

      click_button 'Make it happen!'

      crewmanship = user.crewmanships.order('id asc').last
      crewmanship.status.should == 'active'
      user.billing_day_of_month.should == Date.today.day
      user.subscription_charges.length == 1
    end
  end


  scenario 'a user (with a past_due crewmanship) tries to join 2nd mission, redirects to edit payment info page, after submitting new details charges immediately' do
    mock_stripe(true)
    user.create_stripe_customer({
      :card => {
        :number => 4242424242424242,
        :exp_month => 01,
        :exp_year => Time.now.year+1
      }
    })
    first_crewmanship = user.crewmanships.create!(:status => 'past_due')
    as_user(user) do
      visit mission_path(mission)
      click_link 'Become a member'

      click_button 'Make it happen!'

      crewmanship = user.crewmanships.order('id asc').last
      crewmanship.status.should == 'active'
      user.billing_day_of_month.should == Date.today.day
      user.subscription_charges.length == 1
    end
  end

  # scenario 'a user (with a trial_expired crewmanship) tries to join 2nd mission, redirects to edit payment info page, after submitting new details charges immediately', :js => true do
  #   mock_stripe(true)
  #   teacher = Factory.create(:user)
  #   course = Factory.create(:course, :mission => mission)
  #   Factory.create(:role, :user => teacher, :course => course, :name => 'teacher')
  #   course.update_attribute(:starts_at, 1.day.ago)

  #   first_crewmanship = user.crewmanships.create!(:status => 'trial_expired')
  #   as_user(user) do
  #     visit mission_path(mission)
  #     save_and_open_page
  #     click_link 'Become a member'

  #     save_and_open_page

  #     click_button 'Make it happen!'

  #     crewmanship = user.crewmanships.order('id asc').last
  #     crewmanship.status.should == 'active'
  #     user.billing_day_of_month.should == Date.today.day
  #     user.subscription_charges.length == 1
  #   end
  # end

  # scenario 'a user coming from a "trial expired" email can input their payment info, be charged and be current' do
  # end

  # scenario 'a user coming from a "payment failed" email can input their payment info, be charged and be current' do
  # end


  # scenario "a user's trial expires tomorrow, but they can add their payment info today" do
  # end

  # scenario "a user wants to rejoin a mission after cancelling it" do
  # end

  # scenario "a user has an active crewmanship and a trial_expired crewmanship, how do they activate the expired one?" do
  # end

  # scenario "a user with an abandoned crewmanship wants to bring it active" do
  # end

end