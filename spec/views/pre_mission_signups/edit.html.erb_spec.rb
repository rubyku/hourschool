require 'spec_helper'

describe "pre_mission_signups/edit" do
  before(:each) do
    @pre_mission_signup = assign(:pre_mission_signup, stub_model(PreMissionSignup,
      :email => "MyString",
      :mission => "MyString",
      :description => "MyText",
      :user => nil
    ))
  end

  it "renders the edit pre_mission_signup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pre_mission_signups_path(@pre_mission_signup), :method => "post" do
      assert_select "input#pre_mission_signup_email", :name => "pre_mission_signup[email]"
      assert_select "input#pre_mission_signup_mission", :name => "pre_mission_signup[mission]"
      assert_select "textarea#pre_mission_signup_description", :name => "pre_mission_signup[description]"
      assert_select "input#pre_mission_signup_user", :name => "pre_mission_signup[user]"
    end
  end
end
