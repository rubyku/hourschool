class AccountsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:new, :create]

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
        redirect_to(learn_url(:admin, :subdomain => @account.subdomain)) && return
      end
    else
      @user = User.new_with_session(params[:user], session)
      @user.valid?
      if (@user.valid? && @account.valid?) && (@user.save && @account.save)
        sign_in('user', @user)
        Membership.create!(:user => @user, :account => @account, :admin => true)
        redirect_to(learn_url(:admin, :subdomain => @account.subdomain)) && return
      end
    end

    # somethings wrong if we made it this far, render form
    @errors = @account.errors.full_messages
    @errors += @user.errors.full_messages unless user_signed_in?
    flash.now['alert'] = "Oops. Double check the errors below."
    render :action => "new"
  end

  def show
    # admins only
    @account = current_account
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
