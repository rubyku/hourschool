class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.create(params[:comment])
    if @comment.save
      if @comment.course.present?
        if current_user == @comment.course.teacher
          @comment.notify_participants_and_students
        else
          @comment.notify_participants
        end
      elsif @comment.mission.present?
        @comment.mission.users.each do |user|
          UserMailer.mission_new_comment(user, @comment.mission, @comment).deliver if user.wants_newsletter? && user != current_user
        end
      end
    end
    if @comment.comment_type == 'rally'
      redirect_to mission_url(@comment.mission, :anchor => 'tab4')
    else
      redirect_to :back
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @child_comment = Comment.new
  end


end
