require 'spec_helper'

describe "topics/new" do
  before(:each) do
    assign(:topic, stub_model(Topic,
      :title => "MyString",
      :user => "",
      :type => false,
      :follow => false
    ).as_new_record)
  end

  it "renders new topic form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => topics_path, :method => "post" do
      assert_select "input#topic_title", :name => "topic[title]"
      assert_select "input#topic_user", :name => "topic[user]"
      assert_select "input#topic_type", :name => "topic[type]"
      assert_select "input#topic_follow", :name => "topic[follow]"
    end
  end
end
