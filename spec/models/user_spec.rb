require 'spec_helper'

describe User do

  describe 'legacy password' do
    describe 'valid_legacy_password?' do
      
    end


    describe 'has_legacy_password?' do
      it 'can be detected' do
        user = Factory.stub(:user, :legacy_password_hash => "asdf", :legacy_password_salt => "qwer")
        user.has_legacy_password?.should be_true
      end

      it "doesn't get set off for non legacy users" do
        user = Factory.stub(:user)
        user.has_legacy_password?.should be_false
      end
    end
  end
end