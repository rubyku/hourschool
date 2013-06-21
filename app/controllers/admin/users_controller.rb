class Admin::UsersController < ApplicationController
before_filter :authenticate_admin!

  def index
    @users    = current_account ? current_account.users.order("created_at DESC").uniq : User.uniq.includes(:memberships, [:memberships => :account])
    @teachers = current_account.roles.where(name: 'teacher').includes(:user).map(&:user).uniq
    @admins   = current_account.memberships.where(admin: true).includes(:user).map(&:user).uniq
    @invite   = Invite.new
  end


  def show
    @user = User.find(params[:id])
  end

end