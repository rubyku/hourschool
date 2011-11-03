class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new, :register]
  before_filter :must_be_admin, :only => [:index, :approve]
  
  def index
    #authenticate admin - change this.
    @courses = Course.where(:status => "proposal")
    @user = current_user
  end
  
  def approve
    p "id is #{params[:id]}"
    @course = Course.find(params[:id])
    @course.update_attribute :status, "approved"
    
    #send email and other stuff here to the teacher
    
    redirect_to courses_path
    
  end

  def show
    @course = Course.find(params[:id])
    @current_course = @course
    #p current_user
    
  end

  def new
    @course = Course.new
    @reqid = params[:req]
    if !@reqid.nil?
      req = Csuggestion.find(@reqid.to_i)
      @reqtitle = req.name
      @reqdescription = req.description
    end
    @random_course = Course.find(rand(Course.count-1) + 1)
  end

  def create
    @course = Course.new(params[:course])
    
    #was it from a request
    from_req = !params[:req].nil?
    
    @user = current_user
    if @course.save
      @crole = Crole.find_by_course_id_and_user_id(@course.id, current_user.id) 
      if @crole.nil?
        @crole = @course.croles.create!(:attending => true, :role => 'teacher')
        @user.croles << @crole
        @user.courses << @course
        @user.save
      end
      #now the course has been saved add it to a city where it belongs
      city = City.find_or_create_by_name_and_state(current_user.city, current_user.state)
      city.courses << @course
      city.save
      
      if from_req
        #delele the suggestion
        Csuggestion.delete(params[:req].to_s)
        #here email people who voted, etc etc
        
      end
      #add to indextank
      #INDEX.document("course_#{@course.id}").add({:text => @course.description, :cid => "course_#{@course.id}", :title => @course.title, :tags => @course.categories.join(' ')})
      #redirect_to @course, :notice => "Successfully created course."
      redirect_to current_user, :notice => "Successfully submitted your proposal"
    else
      render :action => 'new'
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update_attributes(params[:course])
      if params[:course][:photo].blank?  
        redirect_to @course, :notice  => "Successfully updated course."
      else  
        render :action => 'crop'
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @slug = Slug.where(:sluggable_type => 'Course', :sluggable_id => @course.id).first
    @crole = Crole.where(:course_id => @course.id).first
    #@course.destroy
    if current_user.is_teacher_for?(@course)
      
      @user = current_user
      @user.courses.delete(@course)
      @user.save
      Crole.delete(@crole.id)
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
      
       # #remove the relevant crole from user
       #        @user.croles.delete(@user.croles.where(:course_id => @course.id).first)
      
      #remove the course
      @user.courses.delete(@user.courses.where(:id => @course.id).first)
     
      @user.save
      
      respond_to do |format|
        format.html { redirect_to @course }
        format.js { }
      end
     
  end
  
  def register_with_amazon
     @course = Course.find(params[:referenceId])
     
     if @course.price > 0.0
       @payment = Payment.new(
           :transaction_amount => params[:transactionAmount],
           :transaction_id     => params[:transactionId]
         )
         if @payment.save
           @payment.update_attributes(:user => current_user, :course => @course)
             @user = current_user
             @crole = @course.croles.create!(:attending => true, :role => 'student')
             @user.croles << @crole
             @user.courses << @course
             @user.save
           # @course.roles.create(:user => current_user, :role => 'student')
           #            UserMailer.newStudent_email(@course, course_url(@course), current_user).deliver
           #            UserMailer.newStudentToTeacher_email(@course, course_url(@course), current_user).deliver
           #            UserMailer.newStudentToStudent_email(@course, course_url(@course), current_user).deliver
           p "made it"
           redirect_to @course, :notice => 'You have succesfully signed up for the class.'
         else
           p "did not make it"
           redirect_to @course, :notice => "Sorry you couldn't make it this time. Next time?"
         end
     end
     
    
  end
  
  def register
     @course = Course.find(params[:id])
     
      @user = current_user
      @crole = @course.croles.create!(:attending => true, :role => 'student')
      @user.croles << @crole
      @user.courses << @course
      @user.save
     
     
      respond_to do |format|
        format.html { redirect_to @course }
        format.js { }
      end
      
      # @user = current_user
      #       if @course.save
      #         @crole = Crole.find_by_course_id_and_user_id(@course.id, current_user.id) 
      #         if @crole.nil?
      #           @crole = @course.croles.create!(:attending => true, :role => 'teacher')
      #           @user.croles << @crole
      #           @user.courses << @course
      #           @user.save
      #         end
      #         redirect_to @course, :notice => "Successfully created course."
      #       else
      #         render :action => 'new'
      #       end
  end
  
  private
  def must_be_admin
    if !current_user.try(:admin?)
      redirect_to current_user
    end
  end
    
end
