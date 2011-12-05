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

  def profile_teaching
    @user = current_user
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses = @user.courses.where(:status => "proposal")
  end

  def profile_past_taught
  end
  
  def profile_past_attending
  end

  def profile_pending
  end

  def profile_suggest
    @top_suggestions =  Suggestion.tally(
       {  :at_least => 1,
           :at_most => 10000,
           :limit => 100,
           :order => "suggestions.name ASC"
       })
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 6)
  end
  
  def profile_approved
  end
  
  def admin_dashboard
  end

end
