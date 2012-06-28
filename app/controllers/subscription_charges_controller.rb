class SubscriptionChargesController < ApplicationController
  before_filter :authenticate_user!

  # GET /subscriptions
  # GET /subscriptions.json
  def index
    @subscription_charges = SubscriptionCharge.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscription_charge }
    end
  end

  # GET /subscriptions/1
  # GET /subscriptions/1.json
  def show
  end

  # GET /subscriptions/new
  # GET /subscriptions/new.json
  def new
  end

  # GET /subscriptions/1/edit
  def edit
    @subscription_charge = SubscriptionCharge.find(params[:id])
  end

  # POST /subscriptions
  # POST /subscriptions.json
  def create
    # get the credit card details submitted by the form
    token = params[:stripeToken]
    
    if current_user.create_stripe_customer(
         :card => token,
         :description => "user_#{current_user.id}",
         :email => current_user.email
       )
      redirect_to subscription_charge_url(:current), notice: 'Subscription was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /subscriptions/1
  # PUT /subscriptions/1.json
  def update
    @subscription_charge = SubscriptionCharge.find(params[:id])

    respond_to do |format|
      if @subscription_charge.update_attributes(params[:subscription_charge])
        format.html { redirect_to @subscription_charge, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscriptions/1
  # DELETE /subscriptions/1.json
  def destroy
    @subscription_charge = SubscriptionCharge.find(params[:id])
    @subscription_charge.destroy

    respond_to do |format|
      format.html { redirect_to subscription_charge_url }
      format.json { head :no_content }
    end
  end
end
