class Courses::BrowseController < ApplicationController

  def index
    @courses = Course.active.paginate(:page => params[:page]||1)
    @no_courses_in_user_city = Course.joins(:city).where("cities.name = '#{@current_user.city}'").count == 0
  end


  # courses/browse/search_by_city


  def show
    @no_courses_in_user_city = Course.joins(:city).where("cities.name = '#{@current_user.city}'").count == 0
    case params[:id]
    when 'past'
      @courses = Course.past.random.paginate(:page => params[:page]||1)
    when 'city'
      @courses = Course.unscoped.order("date DESC").live.located_in(params[:city]).paginate(:page => params[:page]||1, :per_page => 9)
    when 'tags'
       @courses = Course.active.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 9)
    end
  end

end