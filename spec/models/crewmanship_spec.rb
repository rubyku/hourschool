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
      WebMock.allow_net_connect!
      user = Factory.create(:user)
      crewmanship = user.crewmanships.create!(:status => 'active')
      user.create_stripe_customer({
        :card => {
          :number => 4242424242424242,
          :exp_month => 01,
          :exp_year => Time.now.year+1
        }
      })
      crewmanship.make_active_or_expire
      crewmanship.status.should == 'active'
      user.billing_day_of_month.should == Time.now.day
      user.subscription_charges.count == 1
      WebMock.disable_net_connect!
    end

  end
end

# user with 1 trial_active crewmanship, 2 active crewmanship, 1 trial_expired, 1 compeleted