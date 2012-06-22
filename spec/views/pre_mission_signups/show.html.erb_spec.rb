require 'spec_helper'

describe "pre_mission_signups/show" do
  before(:each) do
    @pre_mission_signup = assign(:pre_mission_signup, stub_model(PreMissionSignup,
      :email => "Email",
      :mission => "Mission",
      :description => "MyText",
      :user => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Mission/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
