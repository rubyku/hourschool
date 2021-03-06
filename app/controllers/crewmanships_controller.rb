class CrewmanshipsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy, :update]
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
  def create
    @crewmanship = @mission.crewmanships.new(params[:crewmanship])
    @crewmanship.user = current_user

    # # credit card details entered?
    # # create a stripe customer with this card
    # if params[:stripeToken].present?
    #   current_user.create_stripe_customer(
    #     :card => params[:stripeToken],
    #     :description => "user_#{current_user.id}",
    #     :email => current_user.email
    #   )
    # end

    # #look at user's existing crewmanships and decide what to do with the new one
    # if current_user.crewmanships.empty?
    #   @crewmanship.status = 'trial_active'
    #   charge_now = false
    #   @crewmanship.trial_expires_at = 30.days.from_now
    # elsif current_user.crewmanships.collect(&:status).include?('trial_active')
    #   @crewmanship.status = 'active'
    #   charge_now = false
    #   @crewmanship.trial_expires_at = current_user.crewmanships.first.trial_expires_at
    # elsif current_user.crewmanships.collect(&:status).include?('active')
    #   @crewmanship.status = 'active'
    #   charge_now = false
    # else
    #   @crewmanship.status = 'active'
    #   charge_now = true
    # end

    if @crewmanship.save
      @crewmanship.update_attributes(:role => 'explorer')
      # if charge_now
      #   current_user.update_attributes(:billing_day_of_month => Date.today.day)
      #   current_user.charge_for_active_crewmanships
      # end

      @crewmanship.mission.users.each do |user|
        UserMailer.delay.mission_new_member(user, @mission, current_user) if user.wants_newsletter? && user != current_user
      end
      redirect_to @mission, notice: 'You have joined this mission!'
    else
      redirect_to @mission, notice: 'We are unable to create the membership for you. Please contact hello@hourschool.com for assistance.'
    end
  end

  # PUT /crewmanships/1
  # PUT /crewmanships/1.json
  def update
    @crewmanship = @mission.crewmanships.find(params[:id])

    respond_to do |format|
      if @crewmanship.update_attributes(params[:crewmanship])
        format.html { redirect_to mission_crewmanship_path, notice: 'Crewmanship was successfully updated.' }
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
    @crewmanship.update_attributes(:status => 'canceled', :canceled_at => Time.zone.now)

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
