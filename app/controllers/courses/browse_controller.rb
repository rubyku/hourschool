class Courses::BrowseController < ApplicationController
  
  def show
    if params[:id] == "past"
      @courses = Course.past.random.paginate(:page => params[:page]||1)
    end
  end
  
end