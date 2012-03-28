class Courses::SeriesController < ApplicationController

  def edit
    @series = current_user.series.find(params[:id])
  end

  def create
    @course = current_user.courses.find(params[:course_id])
    @series = Series.create!(:courses => [@course], :name => @course.name, :schedule => params[:schedule])
    redirect_to edit_courses_series_path(@series)
  end

  def update
    @series = current_user.series.find(params[:id])
    @series.update_attributes(:schedule => params[:schedule])
    redirect_to edit_courses_series_path(@series)
  end
end
