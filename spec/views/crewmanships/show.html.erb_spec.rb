require 'spec_helper'

describe "crewmanships/show" do
  before(:each) do
    @crewmanship = assign(:crewmanship, stub_model(Crewmanship,
      :mission => nil,
      :user => nil,
      :role => "Role",
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Role/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Status/)
  end
end
