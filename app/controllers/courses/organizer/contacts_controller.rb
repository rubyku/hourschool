# courses/3/organizer/contacts
# courses/:course_id
class Courses::Organizer::ContactsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @course = Course.find(params[:course_id])
  end

  def create
    @course = Course.find(params[:course_id])
    UserMailer.contact_teacher(current_user, @course, params[:message]).deliver
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @course
  end


end