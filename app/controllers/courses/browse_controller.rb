class Courses::BrowseController < ApplicationController

  def index
    @courses = Course.active.order(:date, :created_at)
    if community_site?
      @courses = @courses.where('account_id in (?) or account_id is null', Account.public_ids).where(:seed => false)
      if current_user
        @no_courses_in_user_city = Course.joins(:city).where("cities.name = '#{current_user.city}'").count == 0
      else
        @no_courses_in_user_city = false
      end
    else
      @courses = @courses.where(:account_id => current_account.id)
    end
    @courses = @courses.paginate(:page => params[:page], :per_page => 9)
  end


  # courses/browse/search_by_city


  def show
    if current_user
      @no_courses_in_user_city = Course.joins(:city).where("cities.name = '#{current_user.city}'").count == 0
    else
      @no_courses_in_user_city = false
    end

    courses  = Course.live.includes(:roles, [:roles => :user])
    if params[:id] == 'all'
      courses = courses.random
    else
      courses = courses.active.order(:date, :created_at)
    end
    if community_site?
      courses = courses.where(:account_id => Account.public_ids)
    else
      courses = courses.where(:account_id => current_account.id)
    end
    courses  = courses.located_in(params[:city])         if params[:city].present?
    courses  = courses.tagged_with(params[:tag])         if params[:tag].present?
    @courses = courses.paginate(:page => params[:page], :per_page => 9)
    @params  = params
  end

end