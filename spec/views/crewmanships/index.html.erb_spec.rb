require 'spec_helper'

describe "crewmanships/index" do
  before(:each) do
    assign(:crewmanships, [
      stub_model(Crewmanship,
        :mission => nil,
        :user => nil,
        :role => "Role",
        :status => "Status"
      ),
      stub_model(Crewmanship,
        :mission => nil,
        :user => nil,
        :role => "Role",
        :status => "Status"
      )
    ])
  end

  it "renders a list of crewmanships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
