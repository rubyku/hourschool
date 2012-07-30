class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new, :register, :preview, :heart, :register_preview, :feedback]
  before_filter :authenticate_admin!, :only => [:index, :approve]

  def new
    @course = Course.new
    @course.mission = Mission.find(params[:mission_id]) if params[:mission_id].present?
  end

  def create
    @course         = Course.new(params[:course])
    @course.account = current_account if current_account

    @topic = Topic.find(params[:topic_id]) if params[:topic_id].present?

    @user = current_user
    if @course.save
      @course.update_attribute(:status, 'draft')
      @course.topics << @topic if @topic
      @role = Role.find_by_course_id_and_user_id(@course.id, current_user.id)
      if @role.nil?
        @role = @course.roles.create!(:attending => true, :name => 'teacher', :user => current_user)
        if @course.mission && @course.mission.crewmanships.where(:user_id => current_user).blank?
          @course.mission.crewmanships.create!(:mission_id => @course.mission, :user_id => current_user, :status => 'active', :role => 'guide')
        end
        @user.save
      end
      redirect_to @course
    else
      render :action => 'new'
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
    params[:course][:topic_ids] ||= []
    cat = []
    cat << (params[:course][:categories]).to_s
    params[:course].delete(:categories)
    @course.category_list = cat.join(", ").to_s

    respond_to do |format|
      if @course.update_attributes(params[:course])
        if @course.status == 'live'  
          if @course.account.nil?
            current_account = nil
          else 
            current_account = @course.account
          end
          UserMailer.send_class_live_mail(@course.teacher.email, @course.teacher.name, @course, current_account).deliver
          format.html { redirect_to @course, notice: 'Woohoo your event is live!' }
          format.json { head :no_content }
        elsif @course.status == 'draft'
          format.html { redirect_to @course}
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
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
