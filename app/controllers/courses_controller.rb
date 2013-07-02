class CoursesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update, :new]
  before_filter :restrict_draft_access!, :only => [:show]
  before_filter :check_can_create_course, :only => [:create]

  def new
    @course = Course.new
  end

  def check_can_create_course
    @course = Course.new(params[:course])
    @user   = params[:teacher_id].present? ? User.find(params[:teacher_id]) : current_user
    return true if current_user == @user
    return true if current_user.admin?
    if current_account.present?
      return true if current_user.memberships.where(admin: true).where(account_id: current_account.id).first
    end

    flash[:error] = "Oops, looks like you didn't have permission to assign teachers to a class other than yourself."
    render :action => 'new'
  end

  def create
    # @course set above
    # @user   set above
    @course.account = current_account if current_account

    @topic = Topic.find(params[:topic_id]) if params[:topic_id].present?

    if @course.save
      @course.update_attribute(:status, 'draft')
      @course.topics << @topic if @topic
      @role = Role.find_by_course_id_and_user_id(@course.id, @user.id)
      if @role.nil?
        @role = @course.roles.create!(:attending => true, :name => 'teacher', :user => @user)
        @user.save
      end
      redirect_to @course
    else
      render :action => 'new'
    end
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
        if @course.status == 'live' && @course.previous_changes["status"]
          @course.account.nil? ? current_account = nil : current_account = @course.account
          UserMailer.course_live(@course.teacher.email, @course.teacher.name, @course, current_account).deliver
          if (current_account == Account.where(:id => 9).first || current_account == Account.where(:id => 13).first) && @course.account.present?
            @course.account.users.each do |user|
              UserMailer.delay.account_new_course(user, @course.account, @course)
            end
          end
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


  def edit
    enqueue_warm_facebook_cache
    @course = Course.find(params[:id])

    redirect_to @course unless @course.teacher == current_user || current_user.admin?
  end

  def show
    @course = Course.find(params[:id])

    @invite = Invite.new
    @invite.invitable_id = params[:invitable_id]
    @invite.invitable_type = params[:invitable_type]
    @invite.inviter = current_user

    if @course.account_id && @course.account_id == 4
      render template: "courses/#{current_account.subdomain}/show"
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
      redirect_to :back, :alert => "You are not authorized to do this."
    end
  end



  private

  def restrict_draft_access!
    @course = Course.find(params[:id])
    if @course.status != "live" && (current_user.blank? || current_user != @course.teacher)
      redirect_to root_path, :notice => "Oops, looks like you didn't have access to the page you were trying to go to." unless current_user.admin? || admin_of_current_account?
    end
  end

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
