## Find links to old controller actions, move to these controller actions
## Move views
## Fix bugs
## Remove old controller action routes, and controller

# courses/3/attendee/contacts
# courses/:course_id

class Courses::FeedbackController < ApplicationController

  def new
    @course = Course.find(params[:course_id])
  end

  def create
    @course = Course.find(params[:course_id])
    UserMailer.course_feedback(current_user, @course, params[:students], params[:general_feedback]).deliver
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @course
  end
end