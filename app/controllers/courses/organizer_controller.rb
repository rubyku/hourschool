class Courses::OrganizerController < ApplicationController
  before_filter :find_course

  def show
    render "courses/organizer/show/#{params[:id]}"
  end

  def update
    case params[:id].to_sym
    when :cancel
      @course.cancel!
      @course.notify_cancel!(params[:message])
      flash[:notice] = "Class was canceled and students notified"
    when :reschedule
      @course.reschedule(params[:whatevs])
      @course.notify_reschedule!(params[:message])
    end
    redirect_to @course
  end

  protected

  def find_course
    @course = Course.find(params[:course_id])
    authorize! :edit_course, @course
  rescue CanCan::AccessDenied
    flash[:error] = "You are not authorized to access this url"
    redirect_to :back
  end

end