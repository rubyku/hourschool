class Courses::SeriesController < ApplicationController

  def new
    @series = Series.new
  end

  def edit
    @series = current_user.series.find(params[:id])
  end

  def create
    @course = current_user.courses_taught.find(params[:course_id])
    @series = @course.series
    @series ||= Series.create(:courses => [@course], :name => @course.name)
    @series.update_attributes(series_params)
    flash[:notice] = "successfully scheduled: #{@course.name}"
    redirect_to edit_courses_series_path(@series)
  end

  def update
    @series = current_user.series.find(params[:id])
    @series.update_attributes(series_params)
    redirect_to edit_courses_series_path(@series)
  end

  private
  def series_params
    {:schedule => params[:schedule]}.merge(params[:series]||{})
  end
end
