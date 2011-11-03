class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all
  end

  def show
    p current_user
    if params[:id].nil?
      @user = current_user
    else
      
      @user = User.find(params[:id])
      #p current_user
    end
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses = @user.courses.where(:status => "pending")
  end
  
  def profile
    
  end

end
