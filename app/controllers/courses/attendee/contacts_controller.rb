# courses/3/attendee/contacts
# courses/:course_id
class Courses::Attendee::ContactsController < ApplicationController
  
  def new
    @course = Course.find(params[:course_id])
  end

  def create
    @course = Course.find(params[:course_id])
    UserMailer.contact_all_students(current_user, @course, params[:message]).deliver
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @course
  end
  

end