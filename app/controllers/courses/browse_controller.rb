class Courses::BrowseController < ApplicationController

  def index
    if current_user && current_user.zip.present?
      teaser_courses = Course.near(:zip => current_user.zip).active.paginate(:page => params[:page]||1)
    end

    if teaser_courses && teaser_courses.total_entries >= Course::DEFAULT_PER_PAGE
      @courses  = teaser_courses
    else
      @teaser_courses = teaser_courses
      @courses        = Course.active.exclude(@teaser_courses).paginate(:page => params[:page]||1)
    end
  end


  # courses/browse/search_by_city


  def show
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