require 'spec_helper'

describe Role do

  describe 'validations' do
    describe 'presence', do
      it 'prevents roles with no user from saving' do
        role = Factory.stub(:role, :user => nil)
        role.valid?.should be_false
      end

      it 'prevents roles with no course from saving' do
        role = Factory.stub(:role, :course => nil)
        role.valid?.should be_false
      end
    end

    describe 'uniqueness', :db => true do
      it 'prevents duplicate roles' do
        role = Factory.create(:role)
        role = Role.new(:user => role.user, :course => role.course)
        role.valid?.should be_false
      end
    end
  end
end