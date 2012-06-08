require 'spec_helper'

describe Comment do
  describe '#participants_and_students', :db => true  do
    it 'includes the teacher' do
      pending
      comment = Factory.create(:comment)
      # puts "================="
      # puts comment.participants_and_students.inspect
      # puts comment.course.teacher.inspect
      # puts "-----------------"
      comment.participants_and_students.include?(comment.course.teacher).should be_true
    end


    it 'includes a student' do
      pending
      comment = Factory.create(:comment)
      user    = Factory.create(:user)
      comment.course.roles.create(:name => 'student', :user => user)
      comment.participants_and_students.include?(user).should be_true
    end
  end


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