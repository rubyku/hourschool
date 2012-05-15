class Courses::AdminController < ApplicationController
  
  def proposals
    @courses = current_account ? current_account.courses.order('DATE(created_at) DESC') : Course.order('DATE(created_at) DESC').where(:status => "proposal")
    @courses = @courses.where(:account_id => current_account.id, :status => "proposal") if current_account
    @user = current_user
  end
  
  def show_proposal
    @current_course = Course.find(params[:id])
  end
  
  def approve
    @course = Course.find(params[:id])
    @course.update_attribute :status, "approved"

    #send email and other stuff here to the teacher
    UserMailer.send_course_approval_mail(@course.teacher.email, @course.teacher.name,@course).deliver
    redirect_to course_proposals_path
  end
  
  def pending_live
    @courses = current_account ? current_account.courses.order('DATE(created_at) DESC') : Course.order('DATE(created_at) DESC').where(:status => "approved")
    @courses = @courses.where(:account_id => current_account.id, :status => "approved") if current_account
    @user = current_user
  end
  
end