# courses/3/attendee/contacts
# courses/:course_id
class Courses::Attendee::ContactsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @course = Course.find(params[:course_id])
  end

  def create
    @course = Course.find(params[:course_id])

    if current_user == @course.teacher
      if @course.account.nil?
        current_account = nil
      else
        current_account = @course.account
      end
      UserMailer.contact_all_students(current_user, @course, params[:message], current_account).deliver
      flash[:notice] = "Your message has successfully been sent"
      redirect_to @course
    else
      render :text => "Hey mister smarty pants, you can't do that", :status => 418
    end
  end


end