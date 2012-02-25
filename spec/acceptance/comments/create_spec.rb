require 'spec_acceptance_helper'

feature "Acceptance courses#create" do
  let(:user)   { Factory.create(:user) }
  let(:course) { Factory.create(:course) }

  describe 'creating a coment' do

    scenario 'a user comments on a course' do
      pending("course factories working with a teacher")
      as_user(user) do
        visit course_path(course)
        successfully_renders
      end
    end

  end

end
