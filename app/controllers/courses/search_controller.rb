class Courses::SearchController < ApplicationController

  def show
    @courses = Course.search_live(params)
    @params  = params
    @no_courses_found = @courses.count == 0
  end

end