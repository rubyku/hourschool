class UsersController < DashboardsController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, :only => [:make_admin, :new, :create]

  #url --> /missions/:id/users
  def index
    @account     = current_account
    @memberships = @account.memberships.order("created_at DESC").uniq

    @invite = Invite.new
    @invite.invitable_id = params[:invitable_id]
    @invite.invitable_type = params[:invitable_type]
    @invite.inviter = current_user
  end

  def search
    user = params[:q]
    response = User.where('name ilike ?', "#{user}%").limit(10)
    response = response.collect{|u| {:name => u.name, :id => u.id}}
    if response.empty?
      response = [{:name => "Looks like #{params[:q]} isn't a member. Give us their email and we'll send em an invite.", :id => 0}]
    end
    logger.info("RESPONSE:#{response}")
    render :json => response
  end

  def table
    if community_site?
      @users = User.order('DATE(created_at) DESC').includes(:memberships, [:memberships => :account])
    else
      @users = current_account.users
    end
  end

  def show
    # @user = User.me_or_find(params[:id], current_user)
    # @approved_courses = @user.courses.where(:status => "approved")
    # @pending_courses  = @user.courses.where(:status => "proposal")
    # if current_account
    #   @approved_courses = @approved_courses.where(:account_id => current_account.id)
    #   @pending_courses = @pending_courses.where(:account_id => current_account.id)
    # end

    @user            = User.me_or_find(params[:id], current_user)
    feed_query_items = feed_query_items_for_me
    @comment         = current_user.comments.new(params[:comment])

    @compact_feed_items, @can_paginate, @last_item_displayed_at = genericized_feed(feed_query_items, params)

    render :template => 'dashboards/show'
  end

  def profile_teaching
    @user = current_user
    @approved_courses = @user.courses.where(:status => "approved")
    @pending_courses  = @user.courses.where(:status => "proposal")
    if current_account
      @approved_courses = @approved_courses.where(:account_id => current_account.id)
      @pending_courses = @pending_courses.where(:account_id => current_account.id)
    end
  end

  def profile_past_taught
  end

  def profile_past_attending
  end

  def profile_pending
  end

  def profile_suggest
    @top_suggestions =  Suggestion.tally(
        :at_least => 1,
        :at_most  => 10000,
        :limit    => 100,
        :order    => "suggestions.name ASC")
      @suggestions = (@top_suggestions & @suggestions_in_my_location).paginate(:page => params[:page], :per_page => 6)
  end

  def profile_approved
  end

  def admin_dashboard
  end

  def make_admin
    @user = User.find(params[:id])
    if Membership.find_by_user_id_and_account_id(@user.id, current_account.id).update_attribute(:admin, true)
      redirect_to(users_url, :notice => "#{@user.name} is now an admin.")
    else
      redirect_to(users_url, :notice => 'Something went wrong.')
    end
  end

  # admins inviting users
  def new_invite
    @user = User.new
  end

  def send_invite
    # theres a chance that user might already have an account on the community stie
    # so we'll just send them an email about this new school
    @existing_user = User.find_by_email(params[:user][:email])
    if @existing_user
      Membership.create!(:user => @existing_user, :account => current_account, :admin => false) unless Membership.find_by_user_id_and_account_id(@existing_user.id, current_account.id)
      UserMailer.membership_invitation(@existing_user, current_account, current_user, true).deliver
      redirect_to(users_url, :notice => "User invited.")
    else
      @user = User.new(params[:user])
      # set user's password to a random string to keep from
      # hacking devises's password stuff
      password = SecureRandom.hex
      @user.password = password
      @user.password_confirmation = password
      @user.skip_confirmation!
      @user.dont_send_reg_email = true
      if @user.save
        # cant use .send_reset_password_instructions because it will send mail
        @user.send(:generate_reset_password_token!)
        Membership.create!(:user => @user, :account => current_account, :admin => false)
        UserMailer.membership_invitation(@user, current_account, current_user, false).deliver
        redirect_to(users_url, :notice => "User invited.")
      else
        render :new_invite
      end
    end
  end

  def update_card
    @user = current_user
    if params[:stripeToken].present?
      stripe_customer = @user.stripe_customer
      stripe_customer.card = params[:stripeToken]
      stripe_customer.save
    end

    render :layout => false
  end
end
