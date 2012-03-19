class AccountsController < ApplicationController
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
    @user = User.new_with_session(params[:user], session) # devise helper

    # run validations and attach errors to both models
    @user.valid?
    @account.valid?

    if (@user.valid? && @account.valid?) && (@user.save && @account.save)
      sign_in('user', @user)
      Membership.create!(:user => @user, :account => @account, :admin => true)
      redirect_to(account_url(:current, :subdomain => @account.subdomain)) && return
    end

    # somethings wrong if we made it this far, render form
    @errors = @user.errors.full_messages + @account.errors.full_messages
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
end
