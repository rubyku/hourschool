require 'spec_helper'

describe "subscriptions/new" do
  before(:each) do
    assign(:subscription, stub_model(Subscription,
      :subscribable_type => "MyString",
      :subscribable_id => 1,
      :stripe_customer_id => "MyString"
    ).as_new_record)
  end

  it "renders new subscription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => subscriptions_path, :method => "post" do
      assert_select "input#subscription_subscribable_type", :name => "subscription[subscribable_type]"
      assert_select "input#subscription_subscribable_id", :name => "subscription[subscribable_id]"
      assert_select "input#subscription_stripe_customer_id", :name => "subscription[stripe_customer_id]"
    end
  end
end
