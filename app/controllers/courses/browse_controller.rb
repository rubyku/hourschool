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
    case params[:id]
    when 'past'
      @courses = Course.past.random.paginate(:page => params[:page])
    when 'city'
      @courses = Course.unscoped.order("date DESC").live.located_in(params[:city]).paginate(:page => params[:page])
    when 'tags'
       @courses = Course.active.tagged_with(params[:tag]).paginate(:page => params[:page])
    end
    courses  = courses.located_in(params[:city])         if params[:city].present?
    courses  = courses.tagged_with(params[:tag])         if params[:tag].present?
    @courses = courses.paginate(:page => params[:page], :per_page => 9)
    @params  = params
  end

end