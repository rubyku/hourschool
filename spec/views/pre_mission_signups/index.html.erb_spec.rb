require 'spec_helper'

describe "pre_mission_signups/index" do
  before(:each) do
    assign(:pre_mission_signups, [
      stub_model(PreMissionSignup,
        :email => "Email",
        :mission => "Mission",
        :description => "MyText",
        :user => nil
      ),
      stub_model(PreMissionSignup,
        :email => "Email",
        :mission => "Mission",
        :description => "MyText",
        :user => nil
      )
    ])
  end

  it "renders a list of pre_mission_signups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Mission".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
