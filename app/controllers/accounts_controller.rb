class AccountsController < ApplicationController
  before_filter :authenticate_admin!, :only => [:new, :create]

  def new
    @account = Account.new
    @user = User.new
    @errors = []
  end

  def edit
    @account = current_account
  end

  def create
    @account = Account.new(params[:account])
    @account.valid?

    if user_signed_in?
      if @account.valid? && @account.save
        @user = current_user
        Membership.create!(:user => current_user, :account => @account, :admin => true)
        redirect_to(explore_url(:admin, :subdomain => @account.subdomain)) && return
      end
    else
      @user = User.new_with_session(params[:user], session)
      @user.valid?
      if (@user.valid? && @account.valid?) && (@user.save && @account.save)
        sign_in('user', @user)
        Membership.create!(:user => @user, :account => @account, :admin => true)
        redirect_to(explore(:admin, :subdomain => @account.subdomain)) && return
      end
    end

    # somethings wrong if we made it this far, render form
    @errors = @account.errors.full_messages
    @errors += @user.errors.full_messages unless user_signed_in?
    flash.now['alert'] = "Oops. Double check the errors below."
    render :action => "new"
  end

  def show
    @account = current_account

    if current_account == Account.where(:id => 7).first
      redirect_to mission_path(:id => 54)
    end

    if current_account == Account.where(:id => 5).first
      redirect_to mission_path(:id => 7)
    end

    if current_account == Account.where(:id => 2).first
      @courses = Course.order(:starts_at, :created_at)
    else
      @courses = Course.active.order(:starts_at, :created_at)
    end

    unless community_site?
      @courses = @courses.where(:account_id => current_account.id)
    end

  end

  def update
    @account = current_account

    if @account.update_attributes(params[:account])
      redirect_to(root_url, :notice => 'Account was successfully updated.')
    else
      render :action => "edit"
    end
  end

  private

end
