class Courses::BrowseController < ApplicationController

  def index
    @courses = Course.active.order(:date, :created_at).paginate(:page => params[:page], :per_page => 9)
    if current_user
      @no_courses_in_user_city = Course.joins(:city).where("cities.name = '#{current_user.city}'").count == 0
    else
      @no_courses_in_user_city = false
    end
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
    courses  = courses.located_in(params[:city])         if params[:city].present?
    courses  = courses.tagged_with(params[:tag])         if params[:tag].present?
    @courses = courses.paginate(:page => params[:page], :per_page => 9)
    @params  = params
  end

end