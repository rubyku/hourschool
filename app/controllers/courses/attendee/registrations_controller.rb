class Courses::Attendee::RegistrationsController < ApplicationController
  before_filter :authenticate_user!
  # TODO, validate user has paid

  # if free 
  #   register!
  # else
  #   redirect_to :paypal
  # end
  def create
    @course = Course.find(params[:course_id])
    @user   = current_user
    @role   = @course.roles.new(:attending => true, :name => 'student', :user => current_user)

    if @role.save
      if !community_site?
        Membership.create(:user => @user, :account => @course.account, :admin => false) 
      end
      if @course.account.nil? 
        current_account = nil
      else 
        current_account = @course.account
      end
      UserMailer.send_course_registration_mail(current_user.email, current_user.name, @course, current_account).deliver
      UserMailer.send_course_registration_to_teacher_mail(current_user.email, current_user.name, @course, current_account).deliver
    else
      if @course.is_a_student? @user
        flash[:error] = "You are already registered for this course"
      else
        flash[:error] = "We couldn't register you for this course, please contact hello@hourschool.com for help"
      end
    end

    respond_to do |format|
      format.html do
        redirect_to course_attendee_registration_path(:course_id => @course, :id => 'confirm')
      end
      format.js { }
    end
  end

  def new
    enqueue_warm_facebook_cache
    @course = Course.find(params[:course_id])
  end


  def show
    id = params[:course_id]
    @course = Course.find(id)

    # temp twitter_hack
    if current_user.blank? || (@course.not_teacher?(current_user) && !current_user.admin?)
      redirect_to @course
    end



  end

  def update    
    @course = Course.find(params[:course_id])
    if @course.status == "approved"
      @course.update_attribute :status, "live"
      if @course.account.nil?
        current_account = nil
      else 
        current_account = @course.account
      end
      UserMailer.send_class_live_mail(@course.teacher.email, @course.teacher.name, @course, current_account).deliver
    end
    render :action => 'show'
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


end