require 'spec_helper'

describe Crewmanship do
  describe 'active' do
    it 'price is full when trial ends' do
      Timecop.return
      crewmanship = Crewmanship.create!(:status => 'active')
      Timecop.travel(30.days.from_now)
      crewmanship.price.should == 10.00
    end

    it 'price is pro-rated from last_invoiced_at' do
      Timecop.travel(Time.local(2012, 6, 25, 12, 0, 0))
      user = Factory.create(:user, :last_invoiced_at => Time.now)
      crewmanship = user.crewmanships.create!(:status => 'active') 
      Timecop.travel(Time.local(2012, 7, 15, 12, 0, 0))
      crewmanship.price.should == 6.45
    end

    it 'user.balance combines crewmanship.prices' do
      Timecop.travel(Time.local(2012, 6, 15, 12, 0, 0))
      user = Factory.create(:user, :last_invoiced_at => Time.local(2012, 7, 15, 12, 0, 0))
      user.crewmanships.create!(:status => 'active') # on jun 15, trial expires jul 15
      Timecop.travel(Time.local(2012, 7, 1, 12, 0, 0))
      user.crewmanships.create!(:status => 'active') # on jul 1, trial expires jul 31
      Timecop.travel(Time.local(2012, 8, 15, 12, 0, 0))
      user.balance.should == 15.16
    end

    it 'user cancels one crewmanship' do
      Timecop.travel(Time.local(2012, 6, 15, 12, 0, 0))
      user = Factory.create(:user, :last_invoiced_at => Time.local(2012, 7, 15, 12, 0, 0))
      user.crewmanships.create!(:status => 'active') # on jun 15, trial expires jul 15
      Timecop.travel(Time.local(2012, 7, 1, 12, 0, 0))
      crewmanship2 = user.crewmanships.create!(:status => 'active') # on jul 1, trial expires jul 31
      Timecop.travel(Time.local(2012, 7, 31, 12, 0, 0))
      crewmanship2.update_attributes(:status => 'canceled', :canceled_at => Time.now)
      Timecop.travel(Time.local(2012, 8, 15, 12, 0, 0))
      user.balance.should == 10.32
    end


  end
end

# user with 1 trial_active crewmanship, 2 active crewmanship, 1 trial_expired, 1 compeleted