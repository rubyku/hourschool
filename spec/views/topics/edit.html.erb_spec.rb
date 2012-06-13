require 'spec_helper'

describe "topics/edit" do
  before(:each) do
    @topic = assign(:topic, stub_model(Topic,
      :title => "MyString",
      :user => "",
      :type => false,
      :follow => false
    ))
  end

  it "renders the edit topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => topics_path(@topic), :method => "post" do
      assert_select "input#topic_title", :name => "topic[title]"
      assert_select "input#topic_user", :name => "topic[user]"
      assert_select "input#topic_type", :name => "topic[type]"
      assert_select "input#topic_follow", :name => "topic[follow]"
    end
  end
end
