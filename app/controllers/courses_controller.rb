class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new]
  
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
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
      redirect_to @course, :notice => "Successfully created course."
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
      redirect_to @course, :notice  => "Successfully updated course."
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
  
  def register
     @course = Course.find(params[:id])
      @user = current_user
      @crole = @course.croles.create!(:attending => true, :role => 'student')
      @user.croles << @crole
      @user.courses << @course
      @user.save
      
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
end
