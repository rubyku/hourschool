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
      mission = Mission.create(:title => 'fishing')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      user.create_stripe_customer({
        :card => {
          :number => 4242424242424242,
          :exp_month => 01,
          :exp_year => Time.now.year+1
        }
      })
      crewmanship.make_active_or_expire
      crewmanship.status.should == 'active'
      user.reload
      user.billing_day_of_month.should == Time.now.day
      user.subscription_charges.count == 1
      WebMock.disable_net_connect!
    end

  #   it "if a user's first crewmanship payment fails, make crewmanships past_due and email them" do

  #     stub_request(:post, "https://08YRJcknyvtlMDhneFawvZ8a3JWveCaW:@api.stripe.com/v1/customers").
  #        with(:body => {"card"=>{"number"=>"4000000000000002", "exp_month"=>"1", "exp_year"=>"2013"}},
  #             :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'67', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Stripe/v1 RubyBindings/1.6.3', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.6.3","lang":"ruby","lang_version":"1.9.3 p-1 (2011-09-23)","platform":"x86_64-darwin11.2.0","publisher":"stripe","uname":"Darwin Ruby-Kus-MacBook-Pro-2.local 11.3.0 Darwin Kernel Version 11.3.0: Thu Jan 12 18:47:41 PST 2012; root:xnu-1699.24.23~1/RELEASE_X86_64 x86_64"}'}).
  #        to_return(:status => 200, :body => '{
  # "created": 1340813823,
  # "object": "customer",
  # "account_balance": 0,
  # "livemode": false,
  # "id": "cus_lYsYL502HANZRS",
  # "active_card": {
  #   "type": "Visa",
  #   "exp_month": 1,
  #   "object": "card",
  #   "exp_year": 2013,
  #   "country": "US",
  #   "fingerprint": "nWCOrcBtvLPsBCze",
  #   "last4": "4242",
  #   "id": "cc_EnNK7Oq6l74Gi9"
  # }', :headers => {})

  #     # WebMock.allow_net_connect!
  #     user = Factory.create(:user)
  #     mission = Mission.create(:title => 'fishing')
  #     crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
  #     user.create_stripe_customer({
  #       :card => {
  #         :number => 4000000000000002,
  #         :exp_month => 01,
  #         :exp_year => Time.now.year+1
  #       }
  #     })
  #     # crewmanship.make_active_or_expire
  #     # charge_for_active_crewmanships
  #     # crewmanship.status.should == 'past_due'
  #     # user.reload
  #     # user.billing_day_of_month.should == Time.now.day
  #     # user.subscription_charges.count == 1
  #     # WebMock.disable_net_connect!
  #   end

    it "users are charged monthly for their active crewmanships" do
      WebMock.allow_net_connect!
      user = Factory.create(:user)
      mission = Mission.create(:title => 'fishing')
      mission2 = Mission.create(:title => 'hiking')
      crewmanship = user.crewmanships.create!(:status => 'active', :mission => mission)
      crewmanship2 = user.crewmanships.create!(:status => 'active', :mission => mission2)
      user.create_stripe_customer({
        :card => {
          :number => 4242424242424242,
          :exp_month => 01,
          :exp_year => Time.now.year+1
        }
      })
      user.charge_for_active_crewmanships
      crewmanship.status.should == 'active'
      crewmanship2.status.should == 'active'
      user.subscription_charges.count == 1
      WebMock.disable_net_connect!
    end

    # it "if a user's monthly charge fails, make crewmanships past_due and email them" do
    #   # make sure we only change active crewmanships to past_due
    # end

    # it "if a user has a past_due crewmanship, allow them to change their payment info, charge it, and bring them into good standing" do
    # end

    # it "if a user has a past_due crewmanship in their next billing date, change status from past due to canceled" do
    # end

    # it "if a user has canceled a crewmanship, make sure they are not charged on their next billing date" do
    # end

  end
end

# user with 1 trial_active crewmanship, 2 active crewmanship, 1 trial_expired, 1 compeleted