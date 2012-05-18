class Courses::AdminController < ApplicationController
  
  def proposals
    @courses = current_account ? current_account.courses.order('DATE(created_at) DESC') : Course.order('DATE(created_at) DESC').where(:status => "nil")
    @courses = @courses.where(:account_id => current_account.id, :status => "nil") if current_account
    @user = current_user
  end
  
  def show_proposal
    @current_course = Course.find(params[:id])
  end
  

  
  def pending_live
    @courses = current_account ? current_account.courses.order('DATE(created_at) DESC') : Course.order('DATE(created_at) DESC').where(:status => "approved")
    @courses = @courses.where(:account_id => current_account.id, :status => "approved") if current_account
    @user = current_user
  end
  
end