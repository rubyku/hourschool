class PreMissionSignupsController < ApplicationController
  # GET /pre_mission_signups
  # GET /pre_mission_signups.json
  def index
    @pre_mission_signups = PreMissionSignup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pre_mission_signups }
    end
  end

  # GET /pre_mission_signups/1
  # GET /pre_mission_signups/1.json
  def show
    @pre_mission_signup = PreMissionSignup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pre_mission_signup }
    end
  end

  # GET /pre_mission_signups/new
  # GET /pre_mission_signups/new.json
  def new
    @pre_mission_signup = PreMissionSignup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pre_mission_signup }
    end
  end

  # GET /pre_mission_signups/1/edit
  def edit
    @pre_mission_signup = PreMissionSignup.find(params[:id])
  end

  # POST /pre_mission_signups
  # POST /pre_mission_signups.json
  def create
    @pre_mission_signup = PreMissionSignup.new(params[:pre_mission_signup])

    respond_to do |format|
      if @pre_mission_signup.save
        format.html { redirect_to @pre_mission_signup, notice: 'Pre mission signup was successfully created.' }
        format.json { render json: @pre_mission_signup, status: :created, location: @pre_mission_signup }
      else
        format.html { render action: "new" }
        format.json { render json: @pre_mission_signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pre_mission_signups/1
  # PUT /pre_mission_signups/1.json
  def update
    @pre_mission_signup = PreMissionSignup.find(params[:id])

    respond_to do |format|
      if @pre_mission_signup.update_attributes(params[:pre_mission_signup])
        format.html { redirect_to @pre_mission_signup, notice: 'Pre mission signup was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pre_mission_signup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_mission_signups/1
  # DELETE /pre_mission_signups/1.json
  def destroy
    @pre_mission_signup = PreMissionSignup.find(params[:id])
    @pre_mission_signup.destroy

    respond_to do |format|
      format.html { redirect_to pre_mission_signups_url }
      format.json { head :no_content }
    end
  end
end
