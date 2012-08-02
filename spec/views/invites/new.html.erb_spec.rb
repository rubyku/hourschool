require 'spec_helper'

describe "invites/new" do
  before(:each) do
    assign(:invite, stub_model(Invite,
      :inviter => nil,
      :invitee => nil,
      :message => "MyText",
      :invitable => nil,
      :invitable_type => "MyString",
      :invite_action => "MyString"
    ).as_new_record)
  end

  it "renders new invite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => invites_path, :method => "post" do
      assert_select "input#invite_inviter", :name => "invite[inviter]"
      assert_select "input#invite_invitee", :name => "invite[invitee]"
      assert_select "textarea#invite_message", :name => "invite[message]"
      assert_select "input#invite_invitable", :name => "invite[invitable]"
      assert_select "input#invite_invitable_type", :name => "invite[invitable_type]"
      assert_select "input#invite_invite_action", :name => "invite[invite_action]"
    end
  end
end
