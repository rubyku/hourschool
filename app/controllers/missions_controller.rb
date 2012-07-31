class MissionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy, :update]
  before_filter :authenticate_admin!, :only => [:index]
  
  # GET /missions
  # GET /missions.json
  def index
    @missions = Mission.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @missions }
    end
  end

  # GET /missions/1
  # GET /missions/1.json
  def show
    @mission = Mission.find(params[:id])
    @users = @mission.users
    @courses = @mission.courses
    @course = Course.new
    @topic = Topic.new
    @invite = Invite.new
    @invite.invitable_id = params[:invitable_id]
    @invite.invitable_type = params[:invitable_type]
    @invite.inviter = current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @mission }
    end
  end

  # GET /missions/new
  # GET /missions/new.json
  def new
    @mission = Mission.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @mission }
    end
  end

  # GET /missions/1/edit
  def edit
    @mission = Mission.find(params[:id])
    #render :layout => 'mission_builder'
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(params[:mission])
    @users = @mission.users
    @courses = @mission.courses
    @course = Course.new
    @topic = Topic.new
    @invite = Invite.new
    @invite.invitable_id = params[:invitable_id]
    @invite.invitable_type = params[:invitable_type]
    @invite.inviter = current_user
    @mission.account = current_account if current_account
    @mission.city = current_user.city

    respond_to do |format|
      if @mission.save
        @mission.crewmanships.create(:user => current_user, :role => 'creator', :status => "trial_active", :trial_expires_at => 30.days.from_now.to_date)
        @mission.update_attribute(:status, 'draft')
        @mission.update_attribute(:featured, false)
        format.html { redirect_to @mission}
      else
        format.html { render action: "new" }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /missions/1
  # PUT /missions/1.json
  def update
    @mission = Mission.find(params[:id])

    respond_to do |format|
      if @mission.update_attributes(params[:mission])
        format.html { redirect_to @mission}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission = Mission.find(params[:id])
    @mission.destroy

    respond_to do |format|
      format.html { redirect_to missions_url }
      format.json { head :no_content }
    end
  end
end
