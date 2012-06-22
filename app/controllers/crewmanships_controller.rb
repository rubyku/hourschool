class CrewmanshipsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update]
  before_filter :find_mission

  # GET /crewmanships
  # GET /crewmanships.json
  def index
    @crewmanships = @mission.crewmanships.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @crewmanships }
    end
  end

  # GET /crewmanships/1
  # GET /crewmanships/1.json
  def show
    @crewmanship = @mission.crewmanships.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @crewmanship }
    end
  end

  # GET /crewmanships/new
  # GET /crewmanships/new.json
  def new
    @crewmanship = @mission.crewmanships.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crewmanship }
    end
  end

  # GET /crewmanships/1/edit
  def edit
    @crewmanship = @mission.crewmanships.find(params[:id])
  end

  # POST /crewmanships
  # POST /crewmanships.json
  def create
    @crewmanship = @mission.crewmanships.new(params[:crewmanship])
    @crewmanship.user = current_user
    @crewmanship.status = 'trial'

    respond_to do |format|
      if @crewmanship.save
        format.html { redirect_to @mission, notice: 'You have joined this mission!' }
        format.json { render json: @mission, status: :created, location: @crewmanship }
      else
        format.html { render action: "new" }
        format.json { render json: @crewmanship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /crewmanships/1
  # PUT /crewmanships/1.json
  def update
    @crewmanship = @mission.crewmanships.find(params[:id])

    respond_to do |format|
      if @crewmanship.update_attributes(params[:crewmanship])
        format.html { redirect_to @crewmanship, notice: 'Crewmanship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @crewmanship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crewmanships/1
  # DELETE /crewmanships/1.json
  def destroy
    @crewmanship = @mission.crewmanships.find(params[:id])
    @crewmanship.update_attributes(:status => 'canceled', :canceled_at => Time.now)

    respond_to do |format|
      format.html { redirect_to crewmanships_url }
      format.json { head :no_content }
    end
  end

  private
  def find_mission
    @mission = Mission.find(params[:mission_id])
  end

end
