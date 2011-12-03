class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all
  end

  def show
    if params[:id].nil?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end
  
  def profile
    @user = current_user
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses = @user.courses.where(:status => "proposal")
  end

  def has_notifications
    @user = current_user
    @approved_courses.any? || @pending_courses.count != 0 || !current_user.photo.exists?
  end
  
  def has_approved_courses
    @user = current_user
    @approved_courses = @user.courses.where(:status => "approved")
    @approved_courses != 0
  end
  
  def has_pending_courses
    @user = current_user
    @pending_courses = @user.courses.where(:status => "proposal")
    @pending_courses.count !=0
  end
  
  def no_photo
    !current_user.photo.exists?
  end
  
  def profile_past
  end

  def profile_pending
  end

  def profile_suggest
  end

end
