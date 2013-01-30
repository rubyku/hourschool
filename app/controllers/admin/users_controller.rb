class Admin::UsersController < ApplicationController

  def index
    @users = current_account ? current_account.users.uniq : User.uniq.includes(:memberships, [:memberships => :account])
    @invite = Invite.new
  end


  def show
    @user = User.find(params[:id])
  end

end