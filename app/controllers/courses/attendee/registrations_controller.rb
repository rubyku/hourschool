class Courses::Attendee::RegistrationsController < ApplicationController
  before_filter :authenticate_user!

  before_filter :check_registered!, :only => :create

  # # ...
  def create
    @course  = Course.find(params[:course_id])
    @mission = @course.mission
    @user    = current_user
    @role    = @course.roles.create(:attending => true, :name => 'student', :user => current_user, :quantity => params[:role][:quantity], :donation => params[:role][:donation])

    @role.create_extra_tickets!

    if @user && params[:stripeToken].present?
      @user.create_stripe_customer(
       :card => params[:stripeToken],
       :description => "user_#{current_user.id}",
       :email => @user.email
      )
    end

    charge = @role.charge_stripe!

    if @role.total_amount == 0 || charge.paid # if charge gets paid successfully
      @role.join_crewhmanship_or_membership!

      UserMailer.course_registration(current_user.email, current_user.name, @course, @role, @course.account).deliver
      UserMailer.course_registration_to_teacher(current_user.email, current_user.name, @course, @course.account).deliver

      redirect_to course_attendee_registration_url(:course_id => @course, :id => 'confirm')
    else
      flash[:error] = "Your charge didn't go through. Please try another card or contact hello@hourschool.com for help."
      redirect_to new_course_attendee_registration_url(@course)
    end
  end

  def new
    enqueue_warm_facebook_cache
    @course = Course.find(params[:course_id])
    @mission = @course.mission
    @role = @course.roles.new
  end


  def show
    @course = Course.find(params[:course_id])
    @role = current_user.roles.where(:course_id => @course.id).first
    # temp twitter_hack
    if current_user.blank? || (@course.not_teacher?(current_user) && !current_user.admin?)
      redirect_to @course
    end
  end

  def update
    @course = Course.find(params[:course_id])
  end

  def destroy
    @course = Course.find(params[:course_id])
    @user = current_user

     # #remove the relevant role from user
     #        @user.roles.delete(@user.roles.where(:course_id => @course.id).first)

    #remove the course
    @user.courses.delete(@user.courses.where(:course_id => @course.id).first)
    @user.save

    respond_to do |format|
      format.html { redirect_to @course }
      format.js { }
    end
  end


  def check_registered!
    if (course = Course.find(params[:course_id])) && course.is_a_student?(current_user)
      flash[:error] = "You are registered for this event."
      redirect_to course_path(course)
    end
    true
  end
end