class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def edit
    @account = current_account
  end

  def create
    @account = Account.new(params[:account])
    
    if @account.save
      redirect_to(learn_url(:subdomain => @account.subdomain))
    else
      flash.now['alert'] = "Oops. Double check the errors below."
      render :action => "new"
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
end
