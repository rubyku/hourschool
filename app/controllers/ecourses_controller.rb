class EcoursesController < ApplicationController  
  skip_before_filter :limit_subdomain_access
  before_filter :authenticate_member!, :only => [:create, :edit, :destroy, :update, :new, :register]
  
  def index
    @courses = Ecourse.all
  end

  def show
    @course = Ecourse.find(params[:id])
    
  end

  def new
    @course = Ecourse.new
    p current_member
    @reqid = params[:req]
    if !@reqid.nil?
      req = Esuggestion.find(@reqid.to_i)
      @reqtitle = req.name
      @reqdescription = req.description
    end
  end

  def create
    @course = Ecourse.new(params[:ecourse])
    
    #was it from a request
    from_req = !params[:req].nil?
    
    @member = current_member
    if @course.save
      @erole = Erole.find_by_course_id_and_member_id(@course.id, current_member.id) 
      if @erole.nil?
        @erole = @course.eroles.create!(:attending => true, :role => 'teacher')
        @member.eroles << @erole
        @member.courses << @course
        @meber.save
      end
      #now the course has been saved add it to a city where it belongs
      ent = Enterprise.find_or_create_by_name_and_domain(current_member.organization, current_member.domain)
      ent.ecourses << @course
      ent.save
      
      if from_req
        #delele the suggestion
        Esuggestion.delete(params[:req].to_s)
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
    @course = Ecourse.find(params[:id])
  end

  def update
    @course = Ecourse.find(params[:id])
    if @course.update_attributes(params[:ecourse])
      redirect_to @course, :notice  => "Successfully updated course."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @course = Ecourse.find(params[:id])
    @slug = Slug.where(:sluggable_type => 'Ecourse', :sluggable_id => @course.id).first
    @erole = Erole.where(:ecourse_id => @course.id).first
    #@course.destroy
    if current_member.is_teacher_for?(@course)
      
      @member = current_member
      @member.ecourses.delete(@course)
      @member.save
      Erole.delete(@erole.id)
      Slug.delete(@slug.id)
      Ecourse.delete(@course.id)
      #INDEX.document("ecourse_#{@course.id}").delete()
      redirect_to ecourses_url, :notice => "Successfully destroyed course."
    else
      redirect_to :back, :alert => "You are not authorized to do this"
    end
    
  end
  
  def register
      @course = Ecourse.find(params[:id])
      @member = current_member
      @erole = @course.eroles.create!(:attending => true, :role => 'student')
      @member.eroles << @erole
      @member.ecourses << @course
      @member.save
     
  end
end
