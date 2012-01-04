class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all
  end

  def show
    @user = User.me_or_find(params[:id], current_user)
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses  = @user.courses.where(:status => "proposal")
  end

end
