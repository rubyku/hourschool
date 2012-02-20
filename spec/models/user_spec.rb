require 'spec_helper'

describe User do

  describe 'user settings' do
    let(:user) { Factory.create(:user) }

    it 'is created automatically after create' do
      user.user_settings.should_not be_nil
    end

    it 'delegates the get properly' do
      user.auto_follow_classmates?.should == user.user_settings.auto_follow_classmates
    end

    it 'delegates the set properly' do
      user.update_attributes(:auto_follow_classmates => false)
      user.user_settings.save
      user.auto_follow_classmates?.should == false
    end
  end

  describe 'legacy password' do
    let(:hash)      {"$2a$10$gty2sE8EyUx9NhQVIcF4RusDu1aTYYwU2Mpih48vYhjOVAumzz6XK"}
    let(:salt)      {"$2a$10$gty2sE8EyUx9NhQVIcF4Ru"}
    let(:password)  {"password"}

    describe 'valid_legacy_password?'do
      it '' do
        user = Factory.stub(:user, :legacy_password_hash => hash, :legacy_password_salt => salt)
        user.valid_legacy_password?(password).should be_true
      end
    end

    describe 'convert_legacy_password!', :db => true  do
      it '' do
        user = Factory.create(:user, :legacy_password_hash => hash, :legacy_password_salt => salt)
        user.convert_legacy_password!(password)
        user.legacy_password_hash.should be_nil
        user.legacy_password_salt.should be_nil
      end
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