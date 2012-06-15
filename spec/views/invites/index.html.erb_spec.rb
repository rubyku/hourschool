require 'spec_helper'

describe "invites/index" do
  before(:each) do
    assign(:invites, [
      stub_model(Invite,
        :inviter => nil,
        :invitee => nil,
        :message => "MyText",
        :invitable => nil,
        :invitable_type => "Invitable Type",
        :invite_action => "Invite Action"
      ),
      stub_model(Invite,
        :inviter => nil,
        :invitee => nil,
        :message => "MyText",
        :invitable => nil,
        :invitable_type => "Invitable Type",
        :invite_action => "Invite Action"
      )
    ])
  end

  it "renders a list of invites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Invitable Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Invite Action".to_s, :count => 2
  end
end
