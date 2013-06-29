class MembershipsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :edit, :destroy, :update]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = current_account.memberships.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @memberships }
    end
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
    @membership = current_account.memberships.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @membership }
    end
  end

  # GET /memberships/new
  # GET /memberships/new.json
  def new
    @membership = current_account.memberships.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @membership }
    end
  end

  # GET /memberships/1/edit
  def edit
    @membership = current_account.memberships.find(params[:id])
  end

  # POST /memberships
  def create
    @membership = current_account.memberships.new(params[:membership])
    @membership.user = current_user

    # # credit card details entered?
    # # create a stripe customer with this card
    # if params[:stripeToken].present?
    #   current_user.create_stripe_customer(
    #     :card => params[:stripeToken],
    #     :description => "user_#{current_user.id}",
    #     :email => current_user.email
    #   )
    # end

    # #look at user's existing memberships and decide what to do with the new one
    # if current_user.memberships.empty?
    #   @membership.status = 'trial_active'
    #   charge_now = false
    #   @membership.trial_expires_at = 30.days.from_now
    # elsif current_user.memberships.collect(&:status).include?('trial_active')
    #   @membership.status = 'active'
    #   charge_now = false
    #   @membership.trial_expires_at = current_user.memberships.first.trial_expires_at
    # elsif current_user.memberships.collect(&:status).include?('active')
    #   @membership.status = 'active'
    #   charge_now = false
    # else
    #   @membership.status = 'active'
    #   charge_now = true
    # end

    if @membership.save
      @membership.update_attributes(:admin => false)
      # if charge_now
      #   current_user.update_attributes(:billing_day_of_month => Date.today.day)
      #   current_user.charge_for_active_memberships
      # end

      redirect_to user_path, notice: 'You have joined this community!'
    else
      redirect_to user_path, notice: 'We are unable to create the membership for you. Please contact hello@hourschool.com for assistance.'
    end
  end

  # PUT /memberships/1
  # PUT /memberships/1.json
  def update
    @membership = current_account.memberships.find(params[:id])

    respond_to do |format|
      if @membership.update_attributes(params[:membership])
        format.html { redirect_to account_membership_path, notice: 'membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership = current_account.memberships.find(params[:id])
    @membership.update_attributes(:status => 'canceled', :canceled_at => Time.zone.now)

    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.json { head :no_content }
    end
  end


end
