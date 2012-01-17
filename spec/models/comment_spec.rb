require 'spec_helper'

describe Comment do
  describe '#participants', :db => true do
    
    # not entirely a valid test since
    it 'includes the teacher' do
      comment = Factory.create(:comment)
      comment.participants.include?(comment.course.teacher).should be_true
    end

    it 'includes the the commenter' do
      comment = Factory.create(:comment)
      comment.participants.include?(comment.user).should be_true
    end
  end
end