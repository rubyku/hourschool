class Admin::UsersController < ApplicationController

  def index
    @users = current_account ? current_account.users.order("created_at DESC").uniq : User.uniq.includes(:memberships, [:memberships => :account])
    @teachers = current_account.users.where(:admin => false).joins(:roles).where("roles.name = 'teacher'").uniq
    @invite = Invite.new
  end


  def show
    @user = User.find(params[:id])
  end

end