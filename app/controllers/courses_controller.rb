class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new]
  
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    p current_user
    
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    @user = current_user
    if @course.save
      @crole = Crole.find_by_course_id_and_user_id(@course.id, current_user.id) 
      if @crole.nil?
        @crole = @course.croles.create!(:attending => true, :role => 'teacher')
        @user.croles << @crole
        @user.courses << @course
        @user.save
      end
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
      redirect_to courses_url, :notice => "Successfully destroyed course."
    else
      redirect_to :back, :alert => "You are not authorized to do this"
    end
    
  end
end
