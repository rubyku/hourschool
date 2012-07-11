class CrewmanshipsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :edit, :destroy, :update]
  before_filter :find_mission
  # before_filter :eligible_for_new_crewmanship, :only => [:create]

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

    if current_user.crewmanships.collect(&:status).include?('canceled')
      @crewmanship.status = 'active'
      charge_now = true
    elsif current_user.crewmanships.collect(&:status).include?('past_due')
      @crewmanship.status = 'active'
      charge_now = true
    elsif current_user.crewmanships.collect(&:status).include?('active')
      @crewmanship.status = 'active'
      charge_now = false
    else
      @crewmanship.status = 'trial_active'
      charge_now = false
    end

    if current_user.crewmanships.count == 0
      @crewmanship.trial_expires_at = 30.days.from_now
    else
      @crewmanship.trial_expires_at = current_user.crewmanships.first.trial_expires_at
    end

    respond_to do |format|
      if @crewmanship.save
        if charge_now
          current_user.update_attributes(:billing_day_of_month => Date.today)
          current_user.charge_for_active_crewmanships
        end
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

  # def eligible_for_new_crewmanship
  #   if current_user.crewmanships.collect(&:status).include?('active')
  #     true
  #   else
  #     redirect_to new_subs
  #   end
  # end

end
