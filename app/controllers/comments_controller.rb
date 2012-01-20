class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.create(params[:comment])
    if @comment.save
      # if current_user = @course.teacher
      #   @comment.notify_participants_and_students
      # else 
        @comment.notify_participants
      # end
    end
    redirect_to :back
  end

end
