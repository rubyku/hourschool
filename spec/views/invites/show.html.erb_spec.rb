require 'spec_helper'

describe "invites/show" do
  before(:each) do
    @invite = assign(:invite, stub_model(Invite,
      :inviter => nil,
      :invitee => nil,
      :message => "MyText",
      :invitable => nil,
      :invitable_type => "Invitable Type",
      :invite_action => "Invite Action"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Invitable Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Invite Action/)
  end
end
