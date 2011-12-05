class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new, :register, :preview, :heart]
  before_filter :must_be_admin, :only => [:index, :approve]
  before_filter :must_be_live, :only => [:show]
  uses_yui_editor

  def index
    #authenticate admin - change this.
    @courses = Course.where(:status => "proposal")
    @user = current_user
  end

  def approve
    @course = Course.find(params[:id])
    @course.update_attribute :status, "approved"

    #send email and other stuff here to the teacher
    UserMailer.send_course_approval_mail(@course.teacher.email, @course.teacher.name,@course).deliver
    redirect_to "/profile-pending"

  end

  def show
    @course = Course.find(params[:id])
    @current_course = @course
    #p current_user

  end

  def show_proposal
    @current_course = Course.find(params[:id])
  end

  def new
    @course = Course.new
    @reqid = params[:req]
    if !@reqid.nil?
      req = Suggestion.find(@reqid.to_i)
      @reqtitle = req.name
      @reqdescription = req.description
    end
    if Course.count > 0
      @random_course = Course.random
    end
  end

  def preview
    id = params[:id]
    @course = Course.find(id)
    @current_course = @course
  end

  def confirm
    id = params[:id]
    @course = Course.find(id)
    if @course.status == "approved"
      @course.update_attribute :status, "live"
      UserMailer.send_class_live_mail(@course.teacher.email, @course.teacher.name, @course).deliver
      UserMailer.send_class_live_to_hourschool_mail(@course.teacher.email, @course.teacher.name, @course).deliver
    end
  end

  def heart
    @course = Course.find(params["id"])
    current_user.vote_for(@course) unless current_user.voted_on?(@course)
  end

  def create
    @course = Course.new(params[:course])

    #was it from a request
    from_req = !params[:req].nil?

    @user = current_user
    if @course.save
      @role = Role.find_by_course_id_and_user_id(@course.id, current_user.id)
      if @role.nil?
        @role = @course.roles.create!(:attending => true, :role => 'teacher')
        @user.roles << @role
        @user.courses << @course
        @user.save
      end
      #now the course has been saved add it to a city where it belongs
      city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.courses << @course
      city.save

      if from_req
        #delele the suggestion
        Suggestion.delete(params[:req].to_s)
        #here email people who voted, etc etc

      end
      #add to indextank
      #INDEX.document("course_#{@course.id}").add({:text => @course.description, :cid => "course_#{@course.id}", :title => @course.title, :tags => @course.categories.join(' ')})
      #redirect_to @course, :notice => "Successfully created course."
      #redirect_to current_user, :notice => "Successfully submitted your proposal"
      UserMailer.send_proposal_received_mail(@course.teacher.email, @course.teacher.name, @course).deliver
      UserMailer.send_proposal_received_to_hourschool_mail(@course.teacher.email, @course.teacher.name, @course).deliver
      
      redirect_to "/profile_teaching"
    else
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
    if @course.teacher == current_user || current_user.is_admin?
    else
       redirect_to @course
    end
  end

  def update
    @course = Course.find(params[:id])
      cat = []
      cat << (params[:course][:categories]).to_s
      params[:course].delete(:categories)
      @course.category_list = cat.join(", ").to_s
      if @course.update_attributes(params[:course])
        puts "saved"
        redirect_to preview_path(:id => @course.id)
      else
        render :action => 'edit'
      end
      puts @course.errors
  end


  def destroy
    @course = Course.find(params[:id])
    @slug = Slug.where(:sluggable_type => 'Course', :sluggable_id => @course.id).first
    @role = Role.where(:course_id => @course.id).first
    #@course.destroy
    if current_user.is_teacher_for?(@course)

      @user = current_user
      @user.courses.delete(@course)
      @user.save
      Role.delete(@role.id)
      Slug.delete(@slug.id)
      Course.delete(@course.id)
      INDEX.document("course_#{@course.id}").delete()
      redirect_to courses_url, :notice => "Successfully destroyed course."
    else
      redirect_to :back, :alert => "You are not authorized to do this"
    end

  end

  def drop
      @course = Course.find(params[:id])

      @user = current_user

       # #remove the relevant role from user
       #        @user.roles.delete(@user.roles.where(:course_id => @course.id).first)

      #remove the course
      @user.courses.delete(@user.courses.where(:id => @course.id).first)

      @user.save

      respond_to do |format|
        format.html { redirect_to @course }
        format.js { }
      end

  end

  def register_preview
    @course = Course.find(params[:id])
  end

  def register
     @course = Course.find(params[:id])

      @user = current_user
      @role = @course.roles.create!(:attending => true, :role => 'student')
      @user.roles << @role
      @user.courses << @course
      if @user.save
        UserMailer.send_course_registration_mail(current_user.email, current_user.name, @course).deliver        
        UserMailer.send_course_registration_to_teacher_mail(current_user.email, current_user.name, @course).deliver
        UserMailer.send_course_registration_to_hourschool_mail(current_user.email, current_user.name, @course).deliver        
        
      end

      respond_to do |format|
        format.html {
          redirect_to course_confirm_path(:id => @course.id)
          }
        format.js { }
      end

      # @user = current_user
      #       if @course.save
      #         @role = Role.find_by_course_id_and_user_id(@course.id, current_user.id)
      #         if @role.nil?
      #           @role = @course.roles.create!(:attending => true, :role => 'teacher')
      #           @user.roles << @role
      #           @user.courses << @course
      #           @user.save
      #         end
      #         redirect_to @course, :notice => "Successfully created course."
      #       else
      #         render :action => 'new'
      #       end
  end

  def register_with_amazon
     @course = Course.find(params[:id])
     
     @payment = Payment.new(
       :transaction_amount => params[:transactionAmount],
       :transaction_id     => params[:transactionId]
     )
      if @payment.save
         @payment.update_attributes(:user => current_user, :course => @course)
         @user = current_user
         @role = @course.roles.create!(:attending => true, :role => 'student')
         @user.roles << @role
         @user.courses << @course
         @user.save
             
       redirect_to course_confirm_path(:id => @course.id)
     else
       redirect_to @course, :notice => "Sorry you couldn't make it this time. Next time?"
     end
  
  end

  def course_confirm
    @course = Course.find(params[:id])
  end

  def contact_teacher
    @course = Course.find(params[:id])
  end

  def contact_teacher_send
    @course = Course.find(params[:id])
    UserMailer.contact_teacher(current_user, @course, params[:message]).deliver
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @course
  end
  
  def contact_all_students
    @course = Course.find(params[:id])
  end

  def contact_all_students_send
    @course = Course.find(params[:id])
    UserMailer.contact_all_students(current_user, @course, params[:message]).deliver
    flash[:notice] = "Your message has successfully been sent"
    redirect_to @course
  end


  private
  def must_be_admin
    #if !current_user.try(:admin?) || !current_user.is_admin?
    if !current_user.is_admin?
      redirect_to user_root_path
    end
  end

  def must_be_live
    @course = Course.find(params[:id])
    if @course.status.present? && @course.status != "live"
      redirect_to user_root_path
    end
  end

end
