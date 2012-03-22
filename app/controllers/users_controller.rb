class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, :only => [:make_admin]
  
  def index
    if community_site?
      @users = User.order('DATE(created_at) DESC').includes(:memberships, [:memberships => :account])
    else
      @users = current_account.users
    end
  end

  def show
    @user = User.me_or_find(params[:id], current_user)
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses  = @user.courses.where(:status => "proposal")
    if current_account
      @approved_courses = @approved_courses.where(:account_id => current_account.id)
      @pending_courses = @pending_courses.where(:account_id => current_account.id)
    end
  end

  def profile_teaching
    @user = current_user
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses  = @user.courses.where(:status => "proposal")
    if current_account
      @approved_courses = @approved_courses.where(:account_id => current_account.id)
      @pending_courses = @pending_courses.where(:account_id => current_account.id)
    end
  end

  def profile_past_taught
  end

  def profile_past_attending
  end

  def profile_pending
  end

  def profile_suggest
    @top_suggestions =  Suggestion.tally(
        :at_least => 1,
        :at_most  => 10000,
        :limit    => 100,
        :order    => "suggestions.name ASC")
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 6)
  end

  def profile_approved
  end

  def admin_dashboard
  end

  def make_admin
    @user = User.find(params[:id])
    if Membership.find_by_user_id_and_account_id(@user.id, current_account.id).update_attribute(:admin, true)
      redirect_to(users_url, :notice => "#{@user.name} is not an admin.")
    else
      redirect_to(users_url, :notice => 'Something went wrong.')
    end
  end

    end
  end
end
