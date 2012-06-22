require 'spec_helper'

describe "subscriptions/index" do
  before(:each) do
    assign(:subscriptions, [
      stub_model(Subscription,
        :subscribable_type => "Subscribable Type",
        :subscribable_id => 1,
        :stripe_customer_id => "Stripe Customer"
      ),
      stub_model(Subscription,
        :subscribable_type => "Subscribable Type",
        :subscribable_id => 1,
        :stripe_customer_id => "Stripe Customer"
      )
    ])
  end

  it "renders a list of subscriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subscribable Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Stripe Customer".to_s, :count => 2
  end
end
