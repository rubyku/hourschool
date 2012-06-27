require 'spec_helper'

describe Crewmanship do
  describe 'active' do
    it 'price is full when trial ends' do
      crewmanship = Crewmanship.create!(:status => 'active')
      crewmanship.price.should == 10.00
    end

    it "user.balance combines crewmanship.prices" do
      user = Factory.create(:user)
      user.crewmanships.create!(:status => 'active') # on jun 15, trial expires jul 15
      user.crewmanships.create!(:status => 'active') # on jun 15, trial expires jul 15
      user.balance.should == 20.00
    end

    it 'user cancels one crewmanship' do
      user = Factory.create(:user)
      crewmanship = user.crewmanships.create!(:status => 'active')
      crewmanship = user.crewmanships.create!(:status => 'canceled', :canceled_at => Time.now)
      user.balance.should == 10.00
    end

    it "a user's first crewmanship (without payment info) should expire" do
      user = Factory.create(:user)
      crewmanship = user.crewmanships.create!(:status => 'active')
      
      crewmanship.make_active_or_expire

      crewmanship.status.should == 'trial_expired'
    end

    it "a user's first crewmanship (with payment info) should become active and be charged" do
      mock_stripe(true)
      user = Factory.create(:user)
      mission = Mission.create(:title => 'fishing')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      user.create_stripe_customer(test_card)
      
      crewmanship.make_active_or_expire
      user.reload
      
      crewmanship.status.should == 'active'
      user.billing_day_of_month.should == Time.now.day
      user.subscription_charges.count == 1
    end

    it "if a user's first crewmanship payment fails, make crewmanships past_due and email them" do
      mock_stripe(false)
      user = Factory.create(:user)
      mission = Mission.create(:title => 'fishing')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      user.create_stripe_customer(test_card)

      crewmanship.make_active_or_expire
      user.reload

      crewmanship.status.should == 'past_due'
      user.billing_day_of_month.should == Time.now.day
      user.subscription_charges.count == 1
    end

    it "users are charged monthly for their active crewmanships" do
      mock_stripe(true)
      user = Factory.create(:user)
      mission = Mission.create(:title => 'fishing')
      mission2 = Mission.create(:title => 'hiking')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      crewmanship2 = user.crewmanships.create!(:status => 'active', :mission => mission2)
      user.create_stripe_customer(test_card)

      user.charge_for_active_crewmanships

      crewmanship.status.should == 'active'
      crewmanship2.status.should == 'active'
      user.subscription_charges.count == 1
    end

    it "if a user's monthly charge fails, make crewmanships past_due and email them", :focus => true do
      mock_stripe(false)
      user = Factory.create(:user)
      mission = Mission.create(:title => 'fishing')
      mission2 = Mission.create(:title => 'hiking')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      crewmanship2 = user.crewmanships.create!(:status => 'canceled', :mission => mission2)
      user.create_stripe_customer(test_card)

      user.charge_for_active_crewmanships
      crewmanship.reload; crewmanship2.reload

      crewmanship.status.should == 'past_due'
      crewmanship2.status.should == 'canceled' # make sure we only change active crewmanships to past_due
      user.subscription_charges.count == 1
    end

    # it "if a user has a past_due crewmanship, allow them to change their payment info, charge it, and bring them into good standing" do
    # end

    # it "if a user has a past_due crewmanship in their next billing date, change status from past due to canceled" do
    # end

    # it "if a user has canceled a crewmanship, make sure they are not charged on their next billing date" do
    # end

  end
end

# user with 1 trial_active crewmanship, 2 active crewmanship, 1 trial_expired, 1 compeleted