require 'spec_helper'

describe "crewmanships/new" do
  before(:each) do
    assign(:crewmanship, stub_model(Crewmanship,
      :mission => nil,
      :user => nil,
      :role => "MyString",
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new crewmanship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => crewmanships_path, :method => "post" do
      assert_select "input#crewmanship_mission", :name => "crewmanship[mission]"
      assert_select "input#crewmanship_user", :name => "crewmanship[user]"
      assert_select "input#crewmanship_role", :name => "crewmanship[role]"
      assert_select "input#crewmanship_status", :name => "crewmanship[status]"
    end
  end
end
