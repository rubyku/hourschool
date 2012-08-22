class Courses::DuplicatesController < ApplicationController

  def new
    @course = Course.find(params[:course_id])
    @series = @course.series || Series.new
  end

  def create
    original_course = current_user.courses_taught.find(params[:course_id])
    @course = Course.duplicate(original_course)
    if @course.save
      @course.roles.create(:attending => true,
                           :name      => 'teacher',
                           :user      => current_user)
      @series = @course.series

      if @series.blank?
        puts "==============================="
        puts({:courses => [@course], :name => @course.name, :schedule => params[:schedule]||{} }.inspect)
        @series = Series.create!(:courses => [@course], :name => @course.name, :schedule => params[:schedule]||{})
      end
      flash[:notice] = "successfully duplicated #{@course.name}"
      redirect_to edit_course_path(@course)
    else
      flash[:error] = 'Could not duplicate this course please contact support.hourschool.com'
      redirect_to :back
    end
  end
end
