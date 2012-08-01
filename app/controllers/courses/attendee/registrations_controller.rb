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
    @mission = @course.mission
    @user   = current_user
    @role   = @course.roles.new(
      :attending => true,
      :name => 'student',
      :user => current_user,
      :quantity => (params[:role][:quantity] || 1)
    )
    if params[:stripeToken].present?
      @user.create_stripe_customer(
       :card => params[:stripeToken],
       :description => "user_#{current_user.id}",
       :email => current_user.email
      )
    end

    if @role.save
      unless @course.free?
        if @user.crewmanships.where(:mission_id => @mission)
          amount = @role.quantity * @course.price
        else
          amount = @role.quantity * (@course.price + 5)
        end
        fee = amount * 0.029 + 0.30
        total = ((amount + fee) * 100).to_i
        charge = Stripe::Charge.create(
          :amount => total,
          :currency => "usd",
          :customer => @user.stripe_customer_id,
          :description => "#{@role.quantity} tickets to #{@course.name}."
        )
        @role.destroy unless charge.paid
      end

      if @course.free? || charge.paid
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
      end
    else
      if @course.is_a_student? @user
        flash[:error] = "You are already registered for this course"
      else
        flash[:error] = "We couldn't register you for this course, please contact hello@hourschool.com for help"
      end
    end

    respond_to do |format|
      format.html do
        if @course.free? || charge.paid
          redirect_to course_attendee_registration_url(:course_id => @course, :id => 'confirm')
        else
          flash[:error] = "Your charge didn't go through, try again or contact hello@hourschool.com for help"
          new_course_attendee_registration_url(@course)
        end
      end
      format.js { }
    end
  end

  def new
    enqueue_warm_facebook_cache
    @course = Course.find(params[:course_id])
    @mission = @course.mission
    @role = @course.roles.new

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