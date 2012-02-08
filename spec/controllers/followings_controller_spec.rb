require 'spec_helper'

describe FollowingsController do
  let(:user) { Factory.create(:user) }

  before(:type => :controller) do
    request.env["HTTP_REFERER"] = "/"
  end


  describe 'create', :db => true do
    it 'works' do
      followed = Factory.create(:user)
      as_user(user).post :create, :user_id => user.id, :id => followed.id, :relationship => 'classmate'
      user.follows?(followed).should be_true
      response.should be_redirect
    end
  end
  
  describe 'destroy', :db => true do
    it 'works' do
      followed = Factory.create(:user)
      user.follow!(followed)
      as_user(user).delete :destroy, :user_id => user.id, :id => followed.id
      user.follows?(followed).should be_false
      response.should be_redirect
    end
  end



end