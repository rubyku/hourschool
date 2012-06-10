class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new, :register, :preview, :heart, :register_preview, :feedback]
  before_filter :authenticate_admin!, :only => [:index, :approve]


  def create
    @course      = Course.new(params[:course])
    @course.account = current_account if current_account
  
    #was it from a request
    from_req = !params[:req].nil?

    @user = current_user
    if @course.save
      @role = Role.find_by_course_id_and_user_id(@course.id, current_user.id)
      if @role.nil?
        @role = @course.roles.create!(:attending => true, :name => 'teacher', :user => current_user)
        @user.save
      end

      if from_req
        #delele the suggestion
        Suggestion.delete(params[:req].to_s)
        # here email people who voted, etc etc
      end

      if admin_of_current_account?
        @course.update_attribute(:status, 'approved')
        redirect_to preview_path(@course)
      else
        @course.update_attribute(:status, 'proposal')
        UserMailer.send_proposal_received_mail(@course.teacher.email, @course.teacher.name, @course).deliver
        redirect_to current_user
      end
    else
      render :action => 'new'
    end
  end

  def new
    @course = Course.new
    @reqid = params[:req]
    if !@reqid.nil?
      req = Suggestion.find(@reqid.to_i)
      @reqtitle = req.name
      @reqdescription = req.description
    end
  end

  def edit
    enqueue_warm_facebook_cache
    @course = Course.find(params[:id])
    if @course.teacher == current_user || current_user.admin?
    else
       redirect_to @course
    end
  end

  def show
    @course = Course.find(params[:id])
    @current_course = @course
  end

  def update
    @course = Course.find(params[:id])
    sanitize_price(params[:course][:price].to_s)
    cat = []
    cat << (params[:course][:categories]).to_s
    params[:course].delete(:categories)
    @course.category_list = cat.join(", ").to_s
    if @course.update_attributes(params[:course])
      redirect_to preview_path(@course)
    else
      render :action => 'edit'
    end
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

  ## ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

  ## "Look over your prososal, if need changes, course#edit, else, course#confirm"
  ## courses#show
  def preview
    id = params[:id]
    @course = Course.find(id)
    @current_course = @course
  end


  ## courses/confirm#show # params[:id] == :teacher || :student
  ## courses/confirm/teacher  
  ## teacher.html.erb student.html.erb
  ## "Congrats! Your class is now live"
  def confirm
    if @course.status == "approved"
        @course.update_attribute :status, "live"
        if @course.account.nil?
          current_account = nil
        else 
          current_account = @course.account
        end
        UserMailer.send_class_live_mail(@course.teacher.email, @course.teacher.name, @course, current_account).deliver
        if community_site?
          post_to_twitter(@course)
        end
    end
  end

##-------------------------------------------------------------------------------------------------------------


  private

  def post_to_twitter(course)
    begin
      client = Twitter::Client.new
      if !current_user.twitter_id.blank?
        message = "New class available in ##{course.city.name.gsub(/ /, '')}! Sign up for \"#{course.title}\" taught by #{'@' unless current_user.twitter_id.include?('@')}#{current_user.twitter_id} "
        if message.size < 125
          client.update(message + url_for(course))
        end
      else
        client.update("New class available in ##{course.city.name.gsub(/ /, '')}! Sign up for \"#{course.title}\" here: #{url_for(course)}")
      end
    rescue Exception => ex
     Rails.logger.error "Twitter Failed: #{ex}"
   end
  end

  def sanitize_price(price)
    if !(price =~ /\$/).nil?
        params[:course][:price] = price.gsub(/\$/, '')
      end
  end

end


## Find links to old controller actions, move to these controller actions
## Move views
## Fix bugs
## Remove old controller action routes