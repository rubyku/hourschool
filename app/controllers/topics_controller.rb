class TopicsController < ApplicationController
  before_filter :find_mission

  # GET /topics
  # GET /topics.json
  def index
    @topics = @mission.topics.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = @mission.topics.find(params[:id])
    @mission = @topic.mission

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = @mission.topics.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = @mission.topics.find(params[:id])
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = @mission.topics.new(params[:topic])
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        @topic.mission.users.each do |user|
          UserMailer.delay.mission_new_topic(user, @topic.mission, @topic) if user.wants_newsletter? && user != current_user
        end
        format.html { redirect_to @mission, notice: 'Topic was successfully created.' }
        format.json { render json: @mission, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end

    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = @mission.topics.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @mission, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = @mission.topics.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end

  private
  def find_mission
    @mission = Mission.find(params[:mission_id])
  end
end
