class CommentsController < ApplicationController

  def index
    @account = current_account
    @comments = Comment.where(:account_id => current_account.id)
  end

  def create
    @comment = current_user.comments.create(params[:comment])
    if @comment.save
      if @comment.course.present?
        if current_user == @comment.course.teacher
          @comment.notify_participants_and_students
        else
          @comment.notify_participants
        end
      elsif @comment.account_id.present? && current_account == Account.where(:id => 9).first
        current_account.users.each do |user|
          UserMailer.delay.account_new_comment(user, current_account, @comment)
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
    @mission = @comment.mission
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      if @comment.mission.present?
        format.html { redirect_to mission_url(@comment.mission) }
        format.json { head :no_content }
      else
        format.html { redirect_to course_url(@comment.course) }
        format.json { head :no_content }
      end
    end
  end

end
