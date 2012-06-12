require 'spec_helper'

describe "missions/index" do
  before(:each) do
    assign(:missions, [
      stub_model(Mission,
        :title => "Title",
        :description => "MyText",
        :account => nil,
        :city => nil
      ),
      stub_model(Mission,
        :title => "Title",
        :description => "MyText",
        :account => nil,
        :city => nil
      )
    ])
  end

  it "renders a list of missions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
