class Courses::SearchController < ApplicationController

  def show
    @courses = Course.search_live(params)
    @params  = params
  end

end