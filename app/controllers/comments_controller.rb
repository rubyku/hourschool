class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.create(params[:comment])
    if @comment.save
      @comment.notify_participants
    end
    redirect_to :back
  end

end
